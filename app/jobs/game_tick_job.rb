class GameTickJob < ApplicationJob
  queue_as :default

  def perform
    GameTick.tick!
  end
end
