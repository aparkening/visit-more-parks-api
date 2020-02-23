class Api::V1::UsersController < ApplicationController

  # Create user
  def create
    # binding.pry
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      cookies["logged_in"] = true
      render json: user, except: [:password_digest]
    else
      render json: { errors: user.errors.full_messages }
    end
  end

  # Delete user
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
  

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

end
