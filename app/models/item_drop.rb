require 'distribution'

class ItemDrop
  # Constants
  RARITY_PROBABILITIES = {
    'poor' => 0.1,
    'common' => 0.45,
    'uncommon' => 0.32,
    'rare' => 0.1195,
    'epic' => 0.01,
    'legendary' => 0.0005
  }

  def initialize(character)
    @character = character
  end

  def item
    @item ||= Item.new(character: @character, level: level, name: name, rarity: rarity, slot: slot)
  end

  private

  def level
    @level ||= begin
      max_level = (@character.level * 1.5).to_i
      rand @character.level..max_level
    end
  end

  def name
    @name ||= ItemName.for(@character, slot, rarity).to_s
  end

  def rarity
    @rarity ||= Distribution::Discrete.new(RARITY_PROBABILITIES).sample
  end

  def slot
    @slot ||= Character::SLOTS.sample
  end
end
