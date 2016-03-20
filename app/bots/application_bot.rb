module ApplicationBot
  extend ActiveSupport::Concern

  included do
    include Cinch::Plugin

    set :prefix, ->(message) { Regexp.new('^' + Regexp.escape(Settings.irc.prefix) + '\s+') }
    hook :pre, method: :load_current_user
    hook :pre, method: :parse_arguments
  end

  class_methods do
    def command(name_and_method, required: 0)
      command_name, command_method_name = *name_and_method.first
      match_method_name = "__before__#{command_method_name}__"

      define_method match_method_name do |message|
        if arguments.size >= required
          __send__ command_method_name, message, *arguments
        else
          message.reply BotHelpTopic.new(command_name).to_s
        end
      end

      match command_name, method: match_method_name
    end
  end

  private

  def arguments
    Thread.current[:blolol_rpg_arguments]
  end

  def current_user
    Thread.current[:blolol_rpg_current_user] ||=
      User.find_or_create_by(name: Thread.current[:blolol_rpg_current_user_name])
  end

  def load_current_user(message)
    Thread.current[:blolol_rpg_current_user_name] = message.user.user
  end

  def parse_arguments(message)
    Thread.current[:blolol_rpg_arguments] = BotArguments.new(self, message).to_a
  end

  def pluralize(count, singular, plural = nil)
    word = if count == 1
      singular
    else
      plural || singular.pluralize
    end

    "#{count || 0} #{word}"
  end

  def sterilize(string)
    Sanitize(Unformat(string))
  end
end
