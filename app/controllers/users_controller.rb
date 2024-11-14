class UsersController < ApplicationController

  def new
  end

  def create

  end

  def show

  end

  def edit

  end

  def update

  end

  def des

  end

  def login
    #renders default view
  end

  def get_session
    user = User.find_user_by_display_name(params[:user_name])
    puts "got user #{user}"
    if user && user.authenticate(params[:password]) && user.update_session_token()
      flash[:alert] = "Login successfull"
      cookies[:session] = {
        value: user.session_token,
        expires: 1.week.from_now
      }
      return redirect_to users_login_path
    end
    flash[:alert] = "Incorrect username and password"
    redirect_to users_login_path
  end

  def logout

  end
end