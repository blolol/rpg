class User < ApplicationRecord
  # Associations
  has_many :characters, dependent: :destroy
  has_one :session, dependent: :destroy

  # Validations
  validates :name, presence: true, uniqueness: true

  def current_character
    session&.character
  end
end
