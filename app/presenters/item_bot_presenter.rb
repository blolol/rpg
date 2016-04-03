class ItemBotPresenter < ApplicationBotPresenter
  # Constants
  COLORS = {
    'poor' => :grey,
    'common' => nil,
    'uncommon' => :green,
    'rare' => :royal,
    'epic' => :purple,
    'legendary' => :orange
  }

  def initialize(item)
    @item = item
  end

  def colored_name
    if color
      Format color, @item.name
    else
      @item.name
    end
  end

  def to_s
    substitutions = {
      colored_name: colored_name,
      level: @item.level,
      rarity: @item.rarity.capitalize,
      slot: @item.slot.capitalize
    }

    '%{colored_name} (%{slot}, %{rarity}, Level %{level})' % substitutions
  end

  private

  def color
    COLORS[@item.rarity]
  end
end
