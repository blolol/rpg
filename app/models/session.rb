class Session < ApplicationRecord
  # Associations
  belongs_to :character
  belongs_to :user

  # Validations
  validates :character, presence: true
  validates :user, presence: true, uniqueness: true
  validate :character_must_belong_to_user

  def tick!
    character.with_lock do
      character.add_xp xp_earned_since_last_tick
      character.save!
      touch
    end

    character.find_item!
  end

  private

  def base_xp_earned_since_last_tick
    (minutes_since_last_tick * Settings.game.base_xp_per_minute).round
  end

  def character_must_belong_to_user
    if character.user != user
      errors.add :base, "Character #{character.name} doesn't belong to user #{user.name}"
    end
  end

  def effect_xp_earned_since_last_tick
    character.effects.sum do |effect|
      effect.xp_earned_since_last_tick minutes_since_last_tick
    end
  end

  def minutes_since_last_tick
    (Time.current - updated_at) / 60
  end

  def xp_earned_since_last_tick
    base_xp_earned_since_last_tick + effect_xp_earned_since_last_tick
  end
end
