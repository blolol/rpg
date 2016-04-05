require 'clockwork'
require_relative 'environment'

module Clockwork
  every Settings.game.seconds_between_ticks, 'game.tick' do
    GameTickJob.perform_later
  end

  every 1.hour, 'game.refresh_premium_effects' do
    RefreshPremiumEffectsJob.perform_later
  end
end
