class UserFavorite < ApplicationRecord
  # Relationships
  belongs_to :user
  belongs_to :park
end
