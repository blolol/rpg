module ApplicationBot
  extend ActiveSupport::Concern
  include Cinch::Plugin

  included do
    set :prefix, ->(message) { Regexp.new('^' + Regexp.escape(Settings.irc.prefix) + '\s+') }
  end
end
