class Api::V1::ParksController < ApplicationController
  before_action :authenticate

  # All parks
  def index
    # Order parks by lattitude 
    parks = Park.all.order(latLong: :asc)
    # Return parks as json
    render json: { parks: parks }
  end

  # Favorite park
  def favorite

binding.pry

    fav = current_user.user_favorites.create(params[:park_id])
    render json: { favorite: fav.id}
  end

  # Delete record
  def unfavorite

binding.pry

    fav = UserFavorite.find(param[:id])

    # Only owner can delete
    authorize_resource(fav)

    # Delete database event
    fav.destroy

    # Render json
    render json: { favorite: fav.id }  
  end

end
