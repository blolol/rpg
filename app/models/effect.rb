class Effect < ApplicationRecord
  # Associations
  belongs_to :effectable, polymorphic: true

  # Delegates
  delegate :session, :user, to: :character

  # Validations
  validates :effectable, presence: true

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

  private

  def character
    if effectable_type == 'Character'
      effectable
    else
      effectable.character
    end
  end
end
