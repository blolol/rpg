require 'clockwork'
require_relative 'environment'

module Clockwork
  every 1.minute, 'game.tick' do
    GameTickJob.perform_later
  end

  every 1.hour, 'game.refresh_premium_effects' do
    RefreshPremiumEffectsJob.perform_later
  end
end
