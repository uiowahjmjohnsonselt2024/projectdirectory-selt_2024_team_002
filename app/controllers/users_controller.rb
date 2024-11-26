# frozen_string_literal: true

# Controller for handling user-related actions.
class UsersController < ApplicationController
  def new
    # render default template
  end

  # rubocop:disable all 
  # rubo cop complains that it's too long. But password confirmation checking should not be in the model
  def create
    form = params[:user]
    if form[:password_confirmation] != form[:password]
      flash[:alert] = 'Password confirmation must match'
      return redirect_to new_user_path
    end
    usr = User.new(email: form[:email], display_name: form[:user_name], password: form[:password])
    if usr.valid? && usr.save
      flash[:notice] = 'Account created successfully'
      return redirect_to users_login_path
    end
    flash[:alert] = usr.errors.empty? ? 'Something went wrong' : usr.errors.full_messages.first
    redirect_to new_user_path
  end

  def show; end

  def edit; end

  def update; end

  def des; end

  def login
    cur_user = User.find_user_by_session_token(cookies[:session])
    if cur_user != nil 
      redirect_to worlds_path
    end
    # renders default view
  end

  def get_session
    user = User.find_user_by_display_name(params[:user_name])
    if user && user.authenticate(params[:password]) && user.update_session_token
      flash[:notice] = 'Login successful'
      cookies[:session] = {
        value: user.session_token,
        expires: 1.week.from_now
      }
      return redirect_to worlds_path
    end
    flash[:alert] = 'Incorrect username and password'
    redirect_to users_login_path
  end

  def logout
    cur_user = User.find_user_by_session_token(cookies[:session])
    flash[:notice] = 'Logout successful'
    cur_user.session_token = nil
    cur_user.save!
    redirect_to users_login_path
  end
end
