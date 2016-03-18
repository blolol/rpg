class SessionsTickJob < ApplicationJob
  queue_as :default

  def perform
    Session.find_each do |session|
      SessionTickJob.perform_later session
    end
  end
end
