class GearScoreModifierEffect < Effect
  # Constants
  DEFAULT_MODIFIER = 0.1

  def description
    "#{modifier_percentage}% gear score #{bonus_or_penalty}"
  end

  def gear_score_modifier
    character.base_gear_score * modifier
  end

  def name
    metadata['name'] || "Gear Score #{bonus_or_penalty.capitalize}"
  end

  def stackable?
    true
  end

  private

  def bonus_or_penalty
    if modifier.negative?
      'penalty'
    else
      'bonus'
    end
  end

  def modifier
    @modifier ||= Float(metadata['modifier'] || DEFAULT_MODIFIER)
  end

  def modifier_percentage
    (modifier * 100).round
  end
end
