class Character < ApplicationRecord
  # Validations
  validates :character_class, presence: true
  validates :level, presence: true,
    numericality: { greater_than_or_equal_to: 1, only_integer: true }
  validates :name, presence: true, uniqueness: true
  validates :owner, presence: true
  validates :xp, presence: true,
    numericality: { greater_than_or_equal_to: 0, only_integer: true }

  def to_s
    "#{name} the Level #{level} #{character_class}"
  end
end
