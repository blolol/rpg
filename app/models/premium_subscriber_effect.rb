class PremiumSubscriberEffect < Effect
  def xp_earned_since_last_tick(minutes_since_last_tick)
    if user.premium?
      (minutes_since_last_tick * Settings.game.premium_xp_per_minute).round
    else
      0
    end
  end
end
