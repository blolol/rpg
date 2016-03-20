class RefreshPremiumEffectsJob < ApplicationJob
  queue_as :default

  def perform
    Character.find_each do |character|
      if character.user.premium?
        character.add_effect PremiumSubscriberEffect.new, replace: false
      else
        character.remove_effects 'PremiumSubscriberEffect'
      end

      character.save!
    end
  end
end
