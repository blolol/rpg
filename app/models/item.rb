class Item < ApplicationRecord
  include Effectable

  # Constants
  RARITIES = %w(poor common uncommon rare epic legendary)

  # Associations
  belongs_to :character
  has_many_effects

  # Validations
  validates :character, presence: true
  validates :level, presence: true,
    numericality: { greater_than_or_equal_to: 1, only_integer: true }
  validates :name, presence: true, length: { maximum: 255 }
  validates :rarity, presence: true, inclusion: { in: RARITIES }
  validates :slot, presence: true, inclusion: { in: Character::SLOTS },
    uniqueness: { scope: :character }

  def self.drop(character, *options)
    ItemDrop.new(character, *options).item
  end

  def to_s
    "#{name} (#{slot.capitalize}, #{rarity.capitalize}, Level #{level})"
  end
end
