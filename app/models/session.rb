class Session < ApplicationRecord
  # Associations
  belongs_to :character
  belongs_to :user

  # Validations
  validates :character, presence: true
  validates :user, presence: true, uniqueness: true
  validate :character_must_belong_to_user

  def last_tick_at
    super || updated_at
  end

  def tick!
    transaction do
      character.add_xp_earned_since_last_tick!
      touch :last_tick_at
    end
  end

  private

  def character_must_belong_to_user
    if character.user != user
      errors.add :base, "Character #{character.name} doesn't belong to user #{user.name}"
    end
  end
end
