class Event < ApplicationRecord
  # Relationships
  belongs_to :user
  belongs_to :park
end
