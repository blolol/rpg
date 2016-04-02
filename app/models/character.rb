class Character < ApplicationRecord
  # Associations
  has_many :effects, dependent: :destroy
  has_one :session, dependent: :destroy
  belongs_to :user

  # Validations
  validates :level, presence: true,
    numericality: { greater_than_or_equal_to: 1, only_integer: true }
  validates :name, presence: true, uniqueness: true
  validates :role, presence: true
  validates :user, presence: true
  validates :xp, presence: true,
    numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :xp_penalty, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  # Callbacks
  define_model_callbacks :level_up
  after_level_up :announce_level_up_in_chat

  def add_effect(effect, replace: true)
    if replace == false && effects.where(type: effect.type).any?
      return effects
    end

    unless effect.stackable?
      remove_effects effect.type
    end

    effects << effect
  end

  def add_xp(additional_xp)
    self.xp += additional_xp
    adjust_level!
  end

  def choose!
    user.with_lock do
      user.session&.destroy
      user.create_session character: self
    end
  end

  def current?
    !!session
  end

  def last_level_at
    super || created_at
  end

  def penalized?
    xp_penalty.positive?
  end

  def remove_effects(type)
    effects.where(type: type).destroy_all
  end

  def to_s
    "#{name} the Level #{level} #{role} (#{xp}/#{xp_required_for_next_level} XP)"
  end

  def xp_required_for_next_level
    base_xp_required_for_next_level + xp_penalty
  end

  private

  def adjust_level!
    while xp >= xp_required_for_next_level do
      run_callbacks :level_up do
        self.xp -= xp_required_for_next_level
        self.level += 1
        self.xp_penalty = 0
        self.last_level_at = Time.current
      end
    end
  end

  def announce_level_up_in_chat
    LevelUpAnnouncementJob.perform_later self, level, xp_required_for_next_level,
      last_level_at_was.iso8601
  end

  def base_xp_required_for_next_level
    xp_required_for_level level.next
  end

  def xp_required_for_level(level)
    (600 * (level ** 1.76)).round
  end
end
