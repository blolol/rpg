class ItemBattleReward < BattleReward
  def actor
    winner
  end

  def apply!
    if winner_wants_item? && winner.equip(item)
      @description = "#{claim_description} #{loser.name}'s #{item_description}"
    elsif item&.destroy
      @description = "#{destruction_description} #{loser.name}'s #{item_description}"
    end
  end

  private

  def claim_description
    case outcome_fairness
    when :fair
      'fairly claimed'
    when :courageous
      'victoriously claimed'
    when :cowardly
      'cowardly stole'
    end
  end

  def destruction_description
    case outcome_fairness
    when :fair
      'destroyed'
    when :courageous
      'victoriously destroyed'
    when :cowardly
      'cruelly destroyed'
    end
  end

  def item
    @item ||= loser.items.where(enduring: false).order(level: :desc).first
  end

  def item_description
    ItemBotPresenter.new(item).to_s
  end

  def item_is_an_upgrade?
    winner.items.where('slot = ? AND level >= ?', item.slot, item.level).empty?
  end

  def winner_wants_item?
    item && item_is_an_upgrade?
  end
end
