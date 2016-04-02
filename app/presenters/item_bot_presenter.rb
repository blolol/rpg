class ItemBotPresenter < ApplicationBotPresenter
  # Constants
  COLORS = {
    'poor' => :grey,
    'common' => :black,
    'uncommon' => :green,
    'rare' => :royal,
    'epic' => :purple,
    'legendary' => :orange
  }

  def initialize(item)
    @item = item
  end

  def to_s
    substitutions = {
      colored_name: colored_name,
      level: @item.level,
      slot: @item.slot.capitalize
    }

    '%{colored_name} (Level %{level})' % substitutions
  end

  private

  def color
    COLORS[@item.rarity]
  end

  def colored_name
    Format color, @item.name
  end
end
