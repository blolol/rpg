class PremiumSubscriberEffect < XpRateModifierEffect
  def name
    'Premium Subscriber'
  end

  def stackable?
    false
  end

  def xp_rate_modifier
    Settings.game.premium_xp_rate_modifier
  end
end
