class ItemBattleReward < BattleReward
  def actor
    winner
  end

  def apply!
    if winner_wants_item? && winner_equipped_item?
      @description = "claimed #{loser.name}'s #{item_description} as a prize"
    elsif item&.destroy
      @description = "spitefully destroyed #{loser.name}'s #{item_description}"
    end

    if winner_gave_dropped_item_to_loser?
      @description << " but, in an act of mercy, left #{loser.name} their " \
        "#{mercy_drop_description}"
    end
  end

  private

  def item
    @item ||= loser.items.where(enduring: false).order(level: :desc).first
  end

  def item_description
    ItemBotPresenter.new(item).to_s
  end

  def item_is_an_upgrade?
    winner.items.where('slot = ? AND level >= ?', item.slot, item.level).empty?
  end

  def mercy_drop_description
    ItemBotPresenter.new(@mercy_drop).to_s
  end

  def winner_equipped_item?
    @drops = winner.equip(item)
    @drops != false
  end

  def winner_gave_dropped_item_to_loser?
    if @drops && @drops.any?
      drop = @drops.sample
      @mercy_drop = drop.dup
      loser.equip @mercy_drop
    end
  end

  def winner_wants_item?
    item && item_is_an_upgrade?
  end
end
