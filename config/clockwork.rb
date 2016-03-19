require 'clockwork'
require_relative 'environment'

module Clockwork
  every 1.minute, 'users.tick' do
    UsersTickJob.perform_later
  end
end
