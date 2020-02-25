class Park < ApplicationRecord
  # Relationships
  has_many :user_favorites, dependent: :destroy
  has_many :events
  has_many :users, through: :events

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

end
