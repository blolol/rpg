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

  def xp_rate_modifier
    @xp_rate_modifier ||= Float(metadata['modifier'] || DEFAULT_MODIFIER)
  end

  private

  def bonus_or_less
    if xp_rate_modifier.positive?
      'bonus'
    else
      'less'
    end
  end

  def bonus_or_penalty
    if xp_rate_modifier.positive?
      'Bonus'
    else
      'Penalty'
    end
  end

  def modifier_percentage
    (xp_rate_modifier.to_f * 100).round
  end
end
