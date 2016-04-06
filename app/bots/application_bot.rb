module ApplicationBot
  extend ActiveSupport::Concern

  # Constants
  Command = Struct.new(:name, :command_method, :required_arguments)
  THREAD_CURRENT_USER_KEY = :blolol_rpg_current_user
  THREAD_CURRENT_USER_NAME_KEY = :blolol_rpg_current_user_name
  THREAD_INVOCATION_KEY = :blolol_rpg_invocation
  THREAD_MESSAGE_KEY = :blolol_rpg_message

  included do
    include ApplicationBotHelper
    include Cinch::Plugin

    # Options
    set :prefix, ->(message) { Regexp.new('^' + Regexp.escape(Settings.irc.prefix) + '\s+') }

    # Hooks
    hook :pre, method: :cache_message
    hook :pre, method: :cache_current_user
    hook :pre, method: :cache_invocation

    # Listeners
    listen_to :message, method: :__listen_for_commands__
  end

  class_methods do
    def __commands__
      @__commands__ ||= []
    end

    def command(options)
      command_name, command_method = *options.first
      required_arguments = options[:required] || 0

      command = Command.new(command_name, command_method, required_arguments)
      __commands__ << command
    end
  end

  private

  def invocation
    Thread.current[THREAD_INVOCATION_KEY]
  end

  def cache_current_user(message)
    Thread.current[THREAD_CURRENT_USER_NAME_KEY] = message.user.user
  end

  def cache_invocation(message)
    Thread.current[THREAD_INVOCATION_KEY] = BotInvocation.new(self, message)
  end

  def cache_message(message)
    Thread.current[THREAD_MESSAGE_KEY] = message
  end

  def current_user
    Thread.current[THREAD_CURRENT_USER_KEY] ||=
      User.find_or_create_by(name: Thread.current[THREAD_CURRENT_USER_NAME_KEY])
  end

  def __execute_command_or_show_help__(command)
    if invocation.arguments.size >= command.required_arguments
      __send__ command.command_method, message, *invocation.arguments
    else
      message.reply BotHelpTopic.new(command.name).to_s
    end
  end

  def __find_and_execute_command__(command_name)
    command = __find_command__(command_name)

    if command
      __execute_command_or_show_help__ command
    end
  end

  def __find_command__(command_name)
    self.class.__commands__.find { |command| command.name == command_name }
  end

  def __listen_for_commands__(message)
    if invocation.command?
      __find_and_execute_command__ invocation.command
    end
  end

  def message
    Thread.current[THREAD_MESSAGE_KEY]
  end
end
