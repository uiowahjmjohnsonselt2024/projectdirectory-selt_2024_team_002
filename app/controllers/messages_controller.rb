# frozen_string_literal: true

# Controller for handling user-related actions.
# rubocop:disable all
class MessagesController < ApplicationController
  before_action :authenticate_user

  def authenticate_user
    @cur_user = User.find_user_by_session_token(cookies[:session])
    return if @cur_user

    flash[:alert] = 'Please login'
    redirect_to users_login_path
  end

  def get_all_messages
    
  end

end
