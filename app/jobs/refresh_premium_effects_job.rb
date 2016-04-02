class RefreshPremiumEffectsJob < ApplicationJob
  queue_as :default

  def perform
    Character.find_each &:refresh_premium_subscriber_effect!
  end
end
