class Park < ApplicationRecord
  # Relationships
  has_many :user_favorites, dependent: :destroy
  has_many :events
  has_many :users, through: :events
end
