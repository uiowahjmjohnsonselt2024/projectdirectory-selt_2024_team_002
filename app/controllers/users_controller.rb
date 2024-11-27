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

  def get_session
    @user = User.find_user_by_display_name(params[:user_name])
    if @user && @user.authenticate(params[:password]) && @user.update_session_token
      flash[:notice] = 'Login successful'
      cookies[:session] = { value: @user.session_token, expires: 1.week.from_now }
      return redirect_to worlds_path
    end
    flash[:alert] = 'Incorrect username and password'
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
      flash.clear
      @currency = currency.upcase
      shard_usd_price = 0.75 # default price in USD
      @rate = (ShardsHelper.get_shard_conversion(@currency) * shard_usd_price).round(2)
      @amount = (Integer(shards) * @rate).round(2)
      @num_of_shards = Integer(shards)

      respond_to do |format|
        format.js
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
end
# rubocop:enable all