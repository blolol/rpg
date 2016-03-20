class User < ApplicationRecord
  # Associations
  has_many :characters, dependent: :destroy
  has_one :session, dependent: :destroy

  # Validations
  validates :name, presence: true, uniqueness: true

  def blolol_metadata
    if blolol_metadata_stale?
      refresh_blolol_metadata
    end

    read_attribute :blolol_metadata
  end

  def current_character
    session&.character
  end

  def find_character(name)
    characters.find_by 'name ILIKE ?', name
  end

  def premium?
    blolol_metadata['roles'].include? 'premium'
  end

  def tick!
    if session
      with_lock { session.tick! }
    end
  end

  private

  def blolol_metadata_stale?
    blolol_metadata_updated_at.nil? || blolol_metadata_updated_at < 1.day.ago
  end

  def refresh_blolol_metadata
    request = BlololApiRequest.new("/users/#{name}")

    if request.ok?
      update! blolol_metadata: request.body['user'], blolol_metadata_updated_at: Time.current
    else
      raise "Error refreshing Blolol metadata for #{name}. status=#{request.status} " \
        "body=#{request.response.body}"
    end
  end
end
