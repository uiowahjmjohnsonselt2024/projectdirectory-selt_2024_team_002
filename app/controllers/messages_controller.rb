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

  def send_message
    world_id = params[:world_id]
    msg = params[:message]
    if msg == nil || msg == ''
      render json: { error: 'Message cannot be empty' }, status: 400
      return
    end
  Message.create!(world_id: world_id, user_id: @cur_user.id, message: msg)
  end
end