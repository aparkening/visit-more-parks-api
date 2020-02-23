class User < ApplicationRecord
  has_secure_password

  # Relationships
  has_many :user_favorites, dependent: :destroy
  has_many :events
  has_many :parks, through: :events
end
