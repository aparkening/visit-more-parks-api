class Api::V1::ParksController < ApplicationController

  # All Parks
  def index
    # Order parks by lattitude 
    parks = Park.all.order(latLong: :asc)
    # Return parks as json
    render json: { parks: parks }
  end

end
