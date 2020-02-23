class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :resource_error

  # Default index
  def index
    authenticate
    render json: { message: "Welcome Home!" }
  end

  protected

  ### Helpers
  # Set current user by session
  def current_user
    User.find_by(id: session[:user_id])
  end

  # Return true if current_user
  def logged_in?
    !!current_user
  end

  ### App Errors
  # Raise error if user doesn't have permission to access
  def authorize_resource(resource)
    raise ActiveRecord::RecordInvalid if !current_user || resource.user != current_user
  end

  # Raise error if user isn't logged in
  def authenticate
    raise ActiveRecord::RecordInvalid if !logged_in?
  end

  ### JSON Errors
  # Render 404 not found
  def not_found(exception)
    # render json: { error: 'Resource not found'}, status: 404
    render json: { error: exception.message }, status: 404
  end

  # Render 400 resourc error
  def resource_error
    render json: { error: 'Resource error. Please update request and try again.'}, status: 400
  end

  # Render 401 unauthorized access
  def not_authorized
    render json: { error: 'Not Authorized'}, status: 401
  end
  

  def bad_csrf
      binding.pry
      # csrf_token = request.headers["HTTP_X_CSRF_TOKEN"]
      # throw "Bad CSRF" unless valid_authenticity_token?(session, csrf_token)
  end


end
