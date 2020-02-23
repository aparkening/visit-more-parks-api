class SessionsController < ApplicationController

  # Log user in and return json
  def login
    user = User.find_by(email: params[:user][:email])
    if user && user.authenticate(params[:user][:password])
        session[:user_id] = user.id
        cookies["logged_in"] = true
        render json: user
    else
        render json: { error: "Invalid Authentication"}, status: 401
    end
  end

  # Display login form
  # def new
  #   @user = User.new
  # end

  # Check user authenticity
  def auth_check
    cookies["logged_in"] = logged_in?
    render json: {csrf_auth_token: form_authenticity_token}
  end

  # Log user out
  def destroy
    authenticate
    session.clear
    render json: { message: "Successfully logged out." }
  end

  # Redirect to Google authorization
  def google_redirect
    redirect_to '/auth/google_oauth2'
  end

  # Create user session and cookie and recirect on successful callback
  def google_callback
    user = User.find_or_create_by_omniauth(auth)

    # Access_token is used to authenticate request made from the rails application to the google server
    # user.google_token = auth.credentials.token
    
    # Refresh_token to request new access_token
    # Note: Refresh_token is only sent once during the first request
    # refresh_token = auth.credentials.refresh_token
    # user.google_refresh_token = refresh_token if refresh_token.present?

    session[:user_id] = user.id
    cookies[:logged_in] = true
    redirect_to 'http://localhost:8000'
  end

  private

  # Set auth to omniauth.auth
  def auth
    request.env['omniauth.auth']
  end

end