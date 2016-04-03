class ItemName
  # Constants
  SLOT_MATERIALS = {
    'chest' => 'armor',
    'feet' => 'armor',
    'head' => 'armor',
    'legs' => 'armor',
    'shoulder' => 'armor',
    'weapon' => 'weapon'
  }

  def self.for(character, slot, rarity)
    case slot
    when 'chest', 'feet', 'head', 'legs', 'shoulder'
      ArmorItemName.new character, slot, rarity
    when 'weapon'
      WeaponItemName.new character, slot, rarity
    end
  end

  def initialize(character, slot, rarity)
    @character = character
    @slot = slot
    @rarity = rarity
  end

  def to_s
    raise NotImplementedError, 'ItemName should not be directly instantiated'
  end

  private

  def possessive
    @possessive ||= begin
      if rand < 0.3
        I18n.t("items.possessives.#{@rarity}").sample % substitutions
      end
    end
  end

  def rarity_probability
    ItemDrop::RARITY_PROBABILITIES[@rarity]
  end

  def substitutions
    @substitutions ||= {
      name: @character.name,
      role: @character.role
    }
  end

  def suffix
    chance = 0.1 + [(suffixes.size * rarity_probability), 0.3].min

    if suffixes.any? && rand < chance
      suffix = suffixes.sample % substitutions
      "of #{suffix}"
    end
  end

  def suffixes
    @suffixes ||= I18n.t("items.suffixes.#{@rarity}")
  end

  def type
    I18n.t("items.#{@slot}").sample
  end

  def quality
    if rand < 0.5
      I18n.t("items.qualities.#{@rarity}").sample
    end
  end
end
