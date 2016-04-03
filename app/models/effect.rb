class Effect < ApplicationRecord
  # Associations
  belongs_to :character
  has_one :session, through: :character
  has_one :user, through: :character

  def description
    raise NotImplementedError
  end

  def gear_score_modifier
    0
  end

  def name
    raise NotImplementedError
  end

  def stackable?
    raise NotImplementedError
  end

  def xp_earned_since_last_tick(minutes_since_last_tick)
    0
  end
end
