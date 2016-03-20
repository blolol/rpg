class PremiumSubscriberEffect < Effect
  def description
    "#{bonus_percentage}% bonus XP earned while idling"
  end

  def name
    'Premium Subscriber'
  end

  def stackable?
    false
  end

  def xp_earned_since_last_tick(minutes_since_last_tick)
    if user.premium?
      (minutes_since_last_tick * Settings.game.premium_xp_per_minute).round
    else
      0
    end
  end

  private

  def bonus_percentage
    ((Settings.game.premium_xp_per_minute.to_f / Settings.game.base_xp_per_minute) * 100).round
  end
end
