class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :load_logged_in_user
  
  def load_logged_in_user
      @logged_in_user = User.find_by_id(session[:current_user_id])
      if not session[:token]
      session[:token] = SecureRandom.urlsafe_base64
      end
  end
  
  def logged_in?
      return @logged_in_user != nil
  end
end
