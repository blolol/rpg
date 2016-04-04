class Character < ApplicationRecord
  include Effectable

  # Constants
  SLOTS = %w(chest feet finger head legs shoulder weapon).freeze

  # Associations
  has_many_effects prefix: 'character'
  has_many :item_effects, through: :items, class_name: 'Effect', source: :effects
  has_many :items, dependent: :destroy
  has_one :session, dependent: :destroy
  belongs_to :user

  # Scopes
  scope :active, -> { joins(:session) }

  # Validations
  validates :level, presence: true,
    numericality: { greater_than_or_equal_to: 1, only_integer: true }
  validates :name, presence: true, uniqueness: true
  validates :role, presence: true
  validates :user, presence: true
  validates :xp, presence: true,
    numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :xp_penalty, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validate :must_have_max_one_item_per_slot

  # Callbacks
  define_model_callbacks :level_up
  after_level_up :announce_level_up_in_chat
  after_create :refresh_premium_subscriber_status!

  def active?
    session.present?
  end

  def add_xp(additional_xp)
    self.xp += additional_xp
    adjust_level!
  end

  def base_gear_score
    items.sum :level
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

  def effects
    character_effects + item_effects
  end

  def equip(item)
    transaction do
      dropped_items = items.where(enduring: false, slot: item.slot).destroy_all

      if items.where(slot: item.slot).empty?
        items << item
        dropped_items
      else
        false
      end
    end
  end

  def find_item!
    FindNewItemJob.perform_later self
  end

  def gear_score
    (base_gear_score + gear_score_modifier_from_effects).round
  end

  def last_level_at
    super || created_at
  end

  def penalized?
    xp_penalty.positive?
  end

  def refresh_premium_subscriber_status!
    ring = PremiumSubscriberRing.new(self)

    if user.premium?
      ring.equip
    else
      ring.unequip
    end
  end

  def to_s
    "#{name} the Level #{level} #{role} (#{xp}/#{total_xp_required_for_next_level} XP, " \
      "#{gear_score} GS)"
  end

  def total_xp_required_for_next_level
    base_xp_required_for_next_level + xp_penalty
  end

  def xp_required_for_next_level
    total_xp_required_for_next_level - xp
  end

  private

  def adjust_level!
    while xp >= total_xp_required_for_next_level do
      run_callbacks :level_up do
        self.xp -= total_xp_required_for_next_level
        self.level += 1
        self.xp_penalty = 0
        self.last_level_at = Time.current
      end
    end
  end

  def announce_level_up_in_chat
    last_level_at = (last_level_at_was || created_at).iso8601
    LevelUpAnnouncementJob.perform_later self, level, total_xp_required_for_next_level,
      last_level_at
  end

  def base_xp_required_for_level(level)
    (600 * (level ** 1.76)).round
  end

  def base_xp_required_for_next_level
    base_xp_required_for_level level.next
  end

  def gear_score_modifier_from_effects
    effects.sum &:gear_score_modifier
  end

  def must_have_max_one_item_per_slot
    SLOTS.each do |slot|
      if items.select { |item| item.slot == slot }.size > 1
        errors.add :items, "can't have more than one item in the #{slot} slot"
      end
    end
  end
end
