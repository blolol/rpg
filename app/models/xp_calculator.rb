class XpCalculator
  def initialize(character)
    @character = character
  end

  def xp_earned_per_tick
    if active?
      (Settings.game.base_xp_per_tick * xp_rate_modifier).round
    else
      0
    end
  end

  def xp_earned_since_last_tick
    if active?
      (ticks_since_last_tick * xp_earned_per_tick).round
    end
  end

  private

  # Delegates
  delegate :active?, :effects, :session, to: :@character
  delegate :last_tick_at, to: :session

  def ticks_since_last_tick
    if active?
      (Time.current - last_tick_at) / Settings.game.seconds_between_ticks.to_f
    end
  end

  def xp_rate_modifier
    1.0 + effects.sum(&:xp_rate_modifier)
  end
end
