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

  def choose!
    User.transaction do
      user.session&.destroy
      user.create_session character: self
    end
  end

  def to_s
    "#{name} the Level #{level} #{role}"
  end
end
