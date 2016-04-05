class XpRateModifierEffect < Effect
  # Constants
  DEFAULT_MODIFIER = 0.1

  def description
    "#{modifier_percentage}% #{bonus_or_less} XP earned while idling"
  end

  def name
    metadata['name'] || "XP #{bonus_or_penalty}"
  end

  def stackable?
    true
  end

  def xp_earned_since_last_tick(minutes_since_last_tick)
    (minutes_since_last_tick * xp_per_tick).round
  end

  private

  def bonus_or_less
    if modifier.positive?
      'bonus'
    else
      'less'
    end
  end

  def bonus_or_penalty
    if modifier.positive?
      'Bonus'
    else
      'Penalty'
    end
  end

  def modifier
    @modifier ||= Float(metadata['modifier'] || DEFAULT_MODIFIER)
  end

  def modifier_percentage
    (modifier.to_f * 100).round
  end

  def xp_per_tick
    (Settings.game.base_xp_per_tick * modifier).round
  end
end
