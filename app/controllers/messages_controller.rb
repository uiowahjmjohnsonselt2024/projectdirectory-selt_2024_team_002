# frozen_string_literal: true

# Controller for handling user-related actions.
# rubocop:disable all
class MessagesController < ApplicationController
  before_action :authenticate_user

  def authenticate_user
    @cur_user = User.find_user_by_session_token(cookies[:session])
    return if @cur_user

    flash[:alert] = 'Please login'
    return redirect_to users_login_path
  end

  def get_all_messages
    world_id = params[:id]
    usr_id = @cur_user.id
    msgs = Message.get_messages_for_world(world_id)
    res = []
    msgs.each do |msg|
      Rails.logger.info("here #{msg.user_id}, #{usr_id}, #{msgs}")
      if msg.user_id == usr_id
        # Create an object (you can customize the object based on your needs)
        res << {
          display_name: "You",
          content: msg.message,
        }
      else 
        res << {
          display_name: User.where(id: msg.user_id).first,
          content: msg.text,
        }
      end

      
    end
    return render json: res

  end
end