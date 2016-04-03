class GameTickJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each do |user|
      UserTickJob.perform_later user
    end
  end
end
