class Session < ApplicationRecord
  # Associations
  belongs_to :character
  belongs_to :user

  # Validations
  validates :character, presence: true
  validates :user, presence: true, uniqueness: true
  validate :character_must_belong_to_user

  private

  def character_must_belong_to_user
    if character.user != user
      errors.add :base, "Character #{character.name} doesn't belong to user #{user.name}"
    end
  end
end
