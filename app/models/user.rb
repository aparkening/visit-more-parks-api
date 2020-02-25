class User < ApplicationRecord
  has_secure_password

  # Relationships
  has_many :user_favorites, dependent: :destroy
  has_many :events
  has_many :parks, through: :events

  # Validations
  # validates :email, presence: true, uniqueness: true
  # validates :password, presence: true, on: :create
  # validates :password, length: { minimum: 6 }, on: :create

  # Find or create user by Omniauth
  def self.find_or_create_by_omniauth(auth)

    # Create new user only if it doesn't exist
    where(uid: auth.uid).first_or_initialize do |user|
      user.uid ||= auth.uid
      user.email = auth.info.email
      user.name = auth.info.name
      user.photo = auth.info.image

      # Access_token is used to authenticate request made from this app to the google server
      user.google_token = auth.credentials.token
      
      # Refresh_token to request new access_token.
      # Note: Refresh_token is only sent once during the first request
      refresh_token = auth.credentials.refresh_token
      user.google_refresh_token = refresh_token if refresh_token.present?

      if !user.password_digest
        pass = SecureRandom.hex(30)
        user.password = pass
        # user.password_confirmation = pass
      end

      user.save
    end
  end

end