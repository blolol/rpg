class PremiumSubscriberRing
  # Constants
  ITEM_ATTRIBUTES = {
    enduring: true,
    level: 1,
    name: "Premium Subscriber's Ring".freeze,
    rarity: 'rare'.freeze,
    slot: 'finger'.freeze
  }.freeze

  def initialize(character)
    @character = character
  end

  def equip
    unless equipped?
      create_ring
    end
  end

  def unequip
    existing_rings.destroy_all
  end

  private

  def create_ring
    @character.transaction do
      @character.items.create(ITEM_ATTRIBUTES).tap do |ring|
        ring.effects.add PremiumSubscriberEffect.new
      end
    end
  end

  def existing_rings
    @character.items.where name: ITEM_ATTRIBUTES[:name], slot: ITEM_ATTRIBUTES[:slot]
  end

  def equipped?
    existing_rings.exists?
  end
end
