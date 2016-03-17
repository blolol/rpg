module ApplicationBot
  extend ActiveSupport::Concern
  include Cinch::Plugin

  included do
    set :prefix, ->(message) { Regexp.new('^' + Regexp.escape(Settings.irc.prefix) + '\s+') }
    hook :pre, method: :parse_arguments
  end

  private

  def arguments
    Thread.current[:blolol_rpg_arguments]
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
