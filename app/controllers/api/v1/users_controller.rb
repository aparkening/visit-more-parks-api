class Api::V1::UsersController < ApplicationController

  # Delete record
  def destroy
    user = User.find(params[:id])

    # Ensure users can only delete themselves
    if user && user.id == current_user.id
      user.destroy
      # Render json
      render json: { user: user.id }, status: 200
    else
      not_authorized
    end
  end
  
end
