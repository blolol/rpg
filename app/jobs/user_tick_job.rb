class UserTickJob < ApplicationJob
  queue_as :default

  def perform(user)
    user.tick!
  end
end
