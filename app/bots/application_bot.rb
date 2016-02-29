module ApplicationBot
  extend ActiveSupport::Concern
  include Cinch::Plugin

  included do
    set :prefix, ->(message) { Regexp.new('^' + Regexp.escape(Settings.irc.prefix) + '\s+') }
  end

  private

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
