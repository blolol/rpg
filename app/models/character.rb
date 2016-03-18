class Character < ApplicationRecord
  # Associations
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

  def add_xp!(additional_xp)
    self.xp += additional_xp
    adjust_level!
  end

  def choose!
    User.transaction do
      user.session&.destroy
      user.create_session character: self
    end
  end

  def to_s
    "#{name} the Level #{level} #{role} (#{xp}/#{xp_required_for_next_level} XP)"
  end

  private

  def adjust_level!
    while xp >= xp_required_for_next_level do
      self.xp -= xp_required_for_next_level
      self.level += 1
    end
  end

  def xp_required_for_level(level)
    (600 * (1.16 ** level)).round
  end

  def xp_required_for_next_level
    xp_required_for_level level.next
  end
end
