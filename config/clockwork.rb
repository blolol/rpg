require 'clockwork'
require_relative 'environment'

module Clockwork
  every 1.minute, 'sessions.tick' do
    SessionsTickJob.perform_later
  end
end
