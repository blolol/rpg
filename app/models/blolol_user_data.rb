class BlololUserData < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :blolol_id, presence: true
  validates :user, presence: true, uniqueness: true
  validates :username, presence: true

  def self.fetch(name)
    user = BlololApiClient.user(name)

    {
      blolol_id: user['id'],
      roles: user['roles'],
      username: user['username']
    }
  end

  def premium?
    roles.include? 'premium'
  end

  def refresh!
    update! self.class.fetch(user.name).merge(updated_at: Time.current)
  end

  def refreshed
    if stale?
      refresh!
    end

    self
  end

  def stale?
    updated_at < 1.day.ago
  end
end
