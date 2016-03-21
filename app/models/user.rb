class User < ApplicationRecord
  # Associations
  has_one :blolol_user_data, dependent: :destroy
  has_many :characters, dependent: :destroy
  has_one :session, dependent: :destroy

  # Validations
  validates :blolol_user_data, presence: true
  validates :name, presence: true, uniqueness: true

  # Callbacks
  before_validation :ensure_blolol_user_data, on: :create

  # Delegates
  delegate :premium?, to: :blolol_user_data

  def blolol_user_data
    super&.refreshed
  end

  def current_character
    session&.character
  end

  def ensure_blolol_user_data
    unless blolol_user_data
      create_blolol_user_data! BlololUserData.fetch(name)
    end
  end

  def find_character(name)
    characters.find_by 'name ILIKE ?', name
  end

  def tick!
    if session
      with_lock { session.tick! }
    end
  end
end
