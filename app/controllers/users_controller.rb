class UsersController < ApplicationController

  def login
    unless session[:current_user_id].nil? then
      flash[:error] = "Please log out before attempting to log in."
      redirect_to url_for(controller: :display, action: :main)
    end
  end

  def logout
    session[:current_user_id] = nil
    redirect_to login_users_path
  end

  def new

    # Comment the next line when in production
    @user = User.new

    # Uncomment the next six lines when in production
    # if session[:current_user_id].nil? then
        # flash[:error] = "You must be logged in."
        # redirect_to login_users_path
    # else
      # @user = User.new
    # end
  end

  def post_login
    user = User.find_by_login params[:login]
    if user && user.password_valid?(params[:password]) then
      session[:current_user_id] = user.id
      session[:user_first_name] = user.first_name
      redirect_to url_for(controller: :display, action: :portfolio)
    else
      flash[:error] = "Username and/or password is incorrect."
      redirect_to login_users_path
    end
  end

  def index
    @users = User.all
  end

  def create
    @user = User.new(user_params(params[:user]))
    if @user.save then
      redirect_to users_path
    else
      render new_user_path
    end
  end

  private
  def user_params(params)
    return params.permit(:first_name, :last_name, :login, :password, :password_confirmation)
  end
end