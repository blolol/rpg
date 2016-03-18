class SessionTickJob < ApplicationJob
  queue_as :default

  def perform(session)
    session.tick!
  end
end
