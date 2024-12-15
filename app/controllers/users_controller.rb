# frozen_string_literal: true

# Controller for handling user-related actions.
# rubocop:disable all
class UsersController < ApplicationController
  require 'credit_card_detector'

  def new
    # render default template
  end

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

  def login
    cur_user = User.find_user_by_session_token(cookies[:session])
    if cur_user != nil 
      redirect_to worlds_path
    end
  end

  def forgot_password
    # renders the forgot password page
  end

  def send_reset_email
    # send email to user
    user = User.find_by_email(params[:email])
    if user
      user.generate_reset_password_token
      UserMailer.send_reset_password_email(user).deliver_now
      flash[:notice] = 'Password reset email sent!'
      return redirect_to users_login_path
    end
    flash[:alert] = 'User not found from the given email'
    redirect_to forgot_password_path
  end

  def reset_password
    @user = User.find_by_reset_password_token(params[:token])
    if @user.nil? || @user.invalid_reset_password_token?
      flash[:alert] = 'Invalid or expired reset link'
      redirect_to users_login_path
    end
  end

  def update_password
    @user = User.find_by_reset_password_token(params[:token])
    if params[:new_password] != params[:confirm_new_password]
      flash[:alert] = 'Password confirmation must match'
      return redirect_to new_user_path
    end
    if @user.update_password(params[:new_password])
      flash[:notice] = 'Password reset successful'
      return redirect_to users_login_path
    end
    flash[:alert] = @user.errors.empty? ? 'Something went wrong' : @user.errors.full_messages.first
    redirect_to reset_password_path
  end

  def get_session
    @user = User.find_user_by_display_name(params[:user_name])
    if @user && @user.authenticate(params[:password]) && @user.update_session_token
      flash[:notice] = 'Login successful'
      cookies[:session] = { value: @user.session_token, expires: 1.week.from_now }
      return redirect_to worlds_path
    end
    flash[:notice] = 'Incorrect username or password'

    redirect_to users_login_path
  end

  def purchase
    @user = User.find_user_by_session_token(cookies[:session])
  end

  def conversion
    shards = params[:shard_input_field]
    currency = params[:currency]

    if shards == ""
      flash[:notice] = 'No amount of shard indicated.'
      redirect_to users_purchase_path
    else
      begin
        raise(ArgumentError) unless shards.match?(/\A\d+\z/)
        flash.clear
        @currency = currency.upcase
        shard_usd_price = 0.75 # default price in USD
        @rate = (ShardsHelper.get_shard_conversion(@currency) * shard_usd_price).round(2)
        @amount = (Integer(shards) * @rate).round(2)
        @num_of_shards = Integer(shards)

        respond_to do |format|
          format.js
        end
      rescue ArgumentError
        flash[:notice] = "Input is not a number. Please try again."
        redirect_to users_purchase_path
      end
    end
  end

  def checkout
    @total_amount = params[:total_amount]
    @with_currency = params[:with_currency]
    @num_of_shards = params[:total_shards]
    @user = User.find_user_by_session_token(cookies[:session])
  end

  def payment
    card_number = params[:card_number]
    expiration_date = params[:expiration_date]
    cvv = params[:cvv]
    billing_address = params[:billing_address]
    num_of_shards = Integer(if params[:total_shards] == "" then 0 else params[:total_shards] end)
    @user = User.find_user_by_session_token(cookies[:session])

    if card_number == "" or expiration_date == "" or cvv == "" or billing_address == ""
      @message = "There is an error on processing. Please check your fields are correct."
      respond_to do |format|
        format.js
      end
    else
      detector = CreditCardDetector::Detector.new(card_number)
      result = detector.valid_luhn?
      unless result
        @message = "Card number is not valid. Please recheck your card number."
        respond_to do |format|
          format.js
        end
        return
      end
      unless expiration_date =~ /\A\d\d\d\d\Z/
        @message = "Expiration date can only be 4 digits. Please try again."
        respond_to do |format|
          format.js
        end
        return
      end
      unless cvv =~ /\A\d\d\d\Z/
        @message = "CVV can only be 3 digits. Please try again."
        respond_to do |format|
          format.js
        end
        return
      end
      @user.update(available_credits: @user.available_credits + num_of_shards)
      redirect_to users_purchase_path
    end
  end

  def logout
    cur_user = User.find_user_by_session_token(cookies[:session])
    flash[:notice] = 'Logout successful'
    cur_user.session_token = nil
    cur_user.save!
    redirect_to users_login_path
  end

  def add_friend
    cur_user = User.find_user_by_session_token(cookies[:session])
    friend_name = params[:friend_name]
    @friend = User.find_by(display_name: friend_name)

    if @friend.nil?
      @message = "User not found."
      respond_to do |format|
        format.js
      end
    elsif @friend == cur_user
      @message = "Unfortunately, you cannot add yourself as a friend."
      respond_to do |format|
        format.js
      end
    else
      existing_friendship = Friendship.find_by(user_id: cur_user.id, friend_id: @friend.id, status: 'accepted')
      inverse_friendship = Friendship.find_by(user_id: @friend.id, friend_id: cur_user.id, status: 'accepted')

      existing_request = Friendship.find_by(user_id: cur_user.id, friend_id: @friend.id, status: 'pending')
      inverse_request = Friendship.find_by(user_id: @friend.id, friend_id: cur_user.id, status: 'pending')

      if existing_friendship || inverse_friendship
        @message = "Friendship already exists!"
        respond_to do |format|
          format.js
        end
      elsif existing_request
        @message = "A request has already been sent!"
        respond_to do |format|
          format.js
        end
      elsif inverse_request
        @message = "This person has sent a request to you already!"
        respond_to do |format|
          format.js
        end
      else
        friendship = Friendship.new(user_id: cur_user.id, friend_id: @friend.id, status: 'pending')

        if friendship.save
          @message = "A friend request has been sent!"
          respond_to do |format|
            format.js
          end
        else
          @message = "Failed to add friendship."
          respond_to do |format|
            format.js
          end
        end
      end
    end
  end

  def delete_friend
    cur_user = User.find_user_by_session_token(cookies[:session])
    @friend = User.find_by(id: params[:friend_id])

    existing_friendship = Friendship.find_by(user_id: cur_user.id, friend_id: params[:friend_id])
    inverse_friendship = Friendship.find_by(user_id: params[:friend_id], friend_id: cur_user.id)

    if existing_friendship
      existing_friendship.destroy
    end
    if inverse_friendship
      inverse_friendship.destroy
    end
    @message = 'Friend removed successfully.'
    respond_to do |format|
      format.js
    end
  end

  def approve_request
    cur_user = User.find_user_by_session_token(cookies[:session])
    @friend = User.find_by(id: params[:friend_id])
    existing_friendship = Friendship.find_by(user_id: cur_user.id, friend_id: params[:friend_id])
    inverse_friendship = Friendship.find_by(user_id: params[:friend_id], friend_id: cur_user.id)

    friendship = existing_friendship || inverse_friendship
    if friendship&.update(status: 'accepted')
      @message = 'Friend accepted!'
    else
      @message = 'Friendship not found!'
    end

    respond_to do |format|
      format.js
    end
  end

  def reject_request
    cur_user = User.find_user_by_session_token(cookies[:session])
    @friend = User.find_by(id: params[:friend_id])

    existing_friendship = Friendship.find_by(user_id: cur_user.id, friend_id: params[:friend_id])
    inverse_friendship = Friendship.find_by(user_id: params[:friend_id], friend_id: cur_user.id)

    if existing_friendship
      existing_friendship.destroy
    end
    if inverse_friendship
      inverse_friendship.destroy
    end
    @message = 'Friend request declined.'
    respond_to do |format|
      format.js
    end
  end

  def send_invite
    @friend = User.find_by(id: params[:friend_id])
    @world = World.find_by(id: params[:world_id])

    existing_world = UserWorld.find_by(user_id: @friend.id, world_id: @world.id, request: false)
    existing_request = UserWorld.find_by(user_id: @friend.id, world_id: @world.id, request: true)
    invite = UserWorld.new(user_id: @friend.id, world_id: @world.id, request: true)
    if existing_request != nil
      @message = "An invite has already been sent for " + invite.world.world_name + "!"
    elsif existing_world != nil
      @message = "This player is already on " + invite.world.world_name + "!"
    elsif invite.save
      @message = "Invite sent!"
    else
      @message = "Failed to send world invite."
    end
    respond_to do |format|
      format.js
    end
  end

  def approve_invite
    @invite = UserWorld.find_by(user_id: params[:user_id], world_id: params[:world_id])
    @world = World.find_by_id(@invite.world_id)
    @user = User.find_by_id(@invite.user_id)
    if @invite&.update(request: false)
      @message = 'Invite accepted!'
    else
      @message = 'Error accepting invite.'
    end
    respond_to do |format|
      format.js
    end
  end

  def reject_invite
    @invite = UserWorld.find_by(user_id: params[:user_id], world_id: params[:world_id])
    if UserWorld.delete(@invite)
      @message = 'Invite rejected.'
    else
      @message = 'Error rejecting invite.'
    end
    respond_to do |format|
      format.js
    end
  end

  def purchase_plus_user_view
    @user = User.find_user_by_session_token(cookies[:session])
  end

  def purchase_plus_user
    @user = User.find_user_by_session_token(cookies[:session])
    if @user.plus_user?
      flash[:alert] = 'You already have Plus User access'
    elsif @user.purchase_plus_user
      flash[:notice] = 'Plus user access purchased successfully'
    else
      flash[:alert] = 'Not enough shards to purchase plus user access'
    end
    redirect_to worlds_path
  end

end
