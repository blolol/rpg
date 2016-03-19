class UsersTickJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each do |session|
      UserTickJob.perform_later session
    end
  end
end
