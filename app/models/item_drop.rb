require 'distribution'

class ItemDrop
  # Constants
  RARITY_PROBABILITIES = {
    'poor' => Rational('7/100'),
    'common' => Rational('45/100'),
    'uncommon' => Rational('36.95/100'),
    'rare' => Rational('10/100'),
    'epic' => Rational('1/100'),
    'legendary' => Rational('0.05/100')
  }

  def initialize(character, level: nil, name: nil, rarity: nil, slot: nil)
    @character = character
    @level = level
    @name = name
    @rarity = rarity
    @slot = slot
  end

  def item
    @item ||= Item.new(character: @character, level: level, name: name, rarity: rarity, slot: slot)
  end

  private

  def level
    @level ||= begin
      min_level = [(@character.level + rarity_index - 1), 1].max
      max_level = (@character.level + (rarity_index ** 1.4)).round
      rand min_level..max_level
    end
  end

  def name
    @name ||= ItemName.for(@character, slot, rarity).to_s
  end

  def rarity
    @rarity ||= Distribution::Discrete.new(RARITY_PROBABILITIES).sample
  end

  def rarity_index
    Item::RARITIES.index rarity
  end

  def slot
    @slot ||= Character::SLOTS.sample
  end
end
