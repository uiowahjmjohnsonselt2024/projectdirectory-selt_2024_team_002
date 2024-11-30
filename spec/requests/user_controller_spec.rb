# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Users', type: :request do
  describe 'create account page' do
    it 'renders the create account page' do
      get new_user_path
      expect(response).to render_template('new')
    end
  end

  describe 'create user' do
    it 'redirects to new_user_path if the password confirmation doesn\'t match' do
      post users_path, params: { user: { password: 'hello', password_confirmation: 'password_confirmation' } }
      expect(response).to redirect_to new_user_path
    end

    # rubocop:disable RSpec/ExampleLength
    it 'redirects to new_user_path if user inputs invalid data' do
      usr = instance_double(User)
      allow(User).to receive(:new).and_return(usr)
      errors = instance_double(ActiveModel::Errors)
      allow(usr).to receive_messages(
        valid?: false,
        errors: errors
      )
      allow(errors).to receive_messages(
        empty?: false,
        full_messages: ['Password can\'t be blank']
      )
      # no display name or email
      post users_path, params: { user: { password: 'hello', password_confirmation: 'password_confirmation' } }
      expect(response).to redirect_to new_user_path
    end

    it 'redirects to new_user_path if the save fails' do
      usr = instance_double(User)
      allow(User).to receive(:new).and_return(usr)
      errors = instance_double(ActiveModel::Errors)
      allow(usr).to receive_messages(
        valid?: true,
        save: false,
        errors: errors
      )
      allow(errors).to receive(:empty?).and_return(true)
      post users_path,
           params: { user: { password: 'J&Jwuth2throsumMo', password_confirmation: 'J&Jwuth2throsumMo',
                             user_name: 'alex', email: 'aguo2@uiowa.edu' } }
      expect(response).to redirect_to new_user_path
    end

    it 'redirect to the login page if the user is created successfully' do
      usr = instance_double(User)
      allow(User).to receive(:new).and_return(usr)
      allow(usr).to receive_messages(
        valid?: true,
        save: true
      )
      post users_path,
           params: { user: { password: 'J&Jwuth2throsumMo', password_confirmation: 'J&Jwuth2throsumMo',
                             user_name: 'alex',             email: 'aguo2@uiowa.edu' } }
      expect(response).to redirect_to users_login_path
    end
  end

  describe 'login page' do
    it 'renders the login page' do
      get users_login_path
      expect(response).to render_template('login')
    end
  end

  describe 'get-session' do
    it 'redirects to the worlds page when correct credentials are entered and the session is correcly saved' do
      usr = instance_double(User)
      allow(User).to receive(:find_user_by_display_name).and_return(usr)
      allow(usr).to receive_messages(
        authenticate: true,
        update_session_token: true,
        session_token: 'asdasdasd'
      )
      post users_get_session_path, params: { password: 'valid', username: 'valid' }
      expect(response).to redirect_to worlds_path
    end

    it 'redirect to the login page when wrong credentials are entered' do
      usr = instance_double(User)
      allow(User).to receive(:find_user_by_display_name).and_return(usr)
      allow(usr).to receive(:authenticate).and_return(false)
      post users_get_session_path, params: { password: 'invalid', username: 'invalid' }
      expect(response).to redirect_to users_login_path
    end

    it 'redirect to the login page when the session fails to save' do
      usr = instance_double(User)
      allow(User).to receive(:find_user_by_display_name).and_return(usr)
      allow(usr).to receive_messages(
        authenticate: true,
        update_session_token: false
      )
      post users_get_session_path, params: { password: 'valid', username: 'valid' }
      expect(response).to redirect_to users_login_path
    end
  end

  describe 'logout' do
    it 'logs the user out' do
      usr = instance_double(User)
      allow(User).to receive(:find_user_by_session_token).and_return(usr)
      allow(usr).to receive(:display_name).and_return('')
      allow(usr).to receive(:save!)
      expect(usr).to receive(:session_token=).with(nil)
      get users_logout_path
    end
  end

  describe 'visiting login when logged in' do
    it 'redirects you to the world page if you have a valid session' do
      usr = instance_double(User)
      allow(User).to receive(:find_user_by_session_token).and_return(usr)
      get users_login_path
      expect(response).to redirect_to worlds_path
    end
  end

  describe 'purchase shard' do
    it 'redirects to purchase shard page' do
      usr = instance_double(User)
      allow(User).to receive(:find_user_by_session_token).and_return(usr)
      allow(usr).to receive(:available_credits).and_return(0)
      get users_purchase_path
      expect(response).to have_http_status(:ok)
    end

    it 'is able to input shard and convert' do
      usr = instance_double(User)
      allow(User).to receive(:find_user_by_session_token).and_return(usr)
      allow(usr).to receive(:available_credits).and_return(0)
      allow(ShardsHelper).to receive(:get_shard_conversion).and_return(10)
      post users_conversion_path, params: { shard_input_field: '34', currency: 'USD' }
      expect(response).to render_template('conversion')
    end

    it 'is able to checkout' do
      usr = instance_double(User)
      allow(User).to receive(:find_user_by_session_token).and_return(usr)
      allow(usr).to receive(:available_credits).and_return(0)
      allow(ShardsHelper).to receive(:get_shard_conversion).and_return(10)
      post users_checkout_path, params: { total_amount: '34.55', with_currency: 'CAD', total_shards: '75' }
      expect(response).to render_template('checkout')
    end

    it 'is able to finish payment and return to shop' do
      usr = instance_double(User)
      allow(User).to receive(:find_user_by_session_token).and_return(usr)
      allow(usr).to receive(:available_credits).and_return(0)
      allow(usr).to receive(:update).with(available_credits: 23).and_return(usr)
      allow(usr).to receive(:update).with(available_credits: 23).and_return(usr)
      allow(ShardsHelper).to receive(:get_shard_conversion).and_return(10)
      post users_payment_path,
           params: { card_number: '30569309025904',
                     expiration_date: '1234',
                     cvv: '754',
                     billing_address: '1234 Test Address',
                     total_shards: '23' }
      expect(response).to redirect_to users_purchase_path
    end
  end

  describe 'forgot password' do
    it 'redirects to the correct location' do
      post users_forgot_password_path
      expect(response).to redirect_to users_login_path
    end
    # TODO: check email seam
  end

  describe 'plus user' do
    it 'redirects successfully' do
      user = instance_double(User)
      allow(User).to receive(:find_user_by_session_token).and_return(user)
      allow(user).to receive(:plus_user?).and_return(true)
      post users_purchase_plus_user_path
      expect(response).to redirect_to worlds_path
    end
  end

  describe 'reject friend request' do
    before do
      usr = instance_double(User)
      friend = instance_double(User)
      allow(User).to receive(:find_by).and_return(friend)
      allow(User).to receive(:find_user_by_session_token).and_return(usr)
      allow(friend).to receive(:id).and_return(0)
      allow(usr).to receive(:id).and_return(0)
      allow(Friendship).to receive(:find_by).and_return(nil)
    end

    it 'sets the correct message' do
      delete users_reject_request_path
      expect(assigns(:message)).to eq('Friend request declined.')
    end

    it 'redirects correctly' do
      delete users_reject_request_path
      expect(response).to render_template('reject_request')
    end
  end

  describe 'users payment' do
    it 'sets the correct message when a field is blank' do
      post users_payment_path, params: { card_number: '', expiration_date: '', billing_address: '', total_shards: 0 }
      expect(assigns(:message)).to eq('There is an error on processing. Please check your fields are correct.')
    end

    it 'sets the correct message when cc is invalid' do
      cc_checker = instance_double(CreditCardDetector::Detector)
      allow(CreditCardDetector::Detector).to receive(:new).and_return(cc_checker)
      allow(cc_checker).to receive(:valid_luhn?).and_return(false)
      post users_payment_path,
           params: { card_number: 'a', expiration_date: '1111', billing_address: '1111', total_shards: 0 }
      expect(assigns(:message)).to eq('Card number is not valid. Please recheck your card number.')
    end

    it 'sets the correct message when exp-date is invalid' do
      cc_checker = instance_double(CreditCardDetector::Detector)
      allow(CreditCardDetector::Detector).to receive(:new).and_return(cc_checker)
      allow(cc_checker).to receive(:valid_luhn?).and_return(true)
      post users_payment_path,
           params: { card_number: 'a', expiration_date: 'aaaa', billing_address: '1111', total_shards: 0 }
      expect(assigns(:message)).to eq('Expiration date can only be 4 digits. Please try again.')
    end

    it 'sets the correct message when ccv is invalid' do
      cc_checker = instance_double(CreditCardDetector::Detector)
      allow(CreditCardDetector::Detector).to receive(:new).and_return(cc_checker)
      allow(cc_checker).to receive(:valid_luhn?).and_return(true)
      post users_payment_path,
           params: { card_number: 'a', expiration_date: '1111', billing_address: '1111', total_shards: 0, ccv: 'aaa' }
      expect(assigns(:message)).to eq('CVV can only be 3 digits. Please try again.')
    end

    it 'redirects correctly' do
      cc_checker = instance_double(CreditCardDetector::Detector)
      allow(CreditCardDetector::Detector).to receive(:new).and_return(cc_checker)
      usr = instance_double(User)
      allow(User).to receive(:find_user_by_session_token).and_return(usr)
      allow(usr).to receive(:available_credits).and_return(0)
      allow(usr).to receive(:update).and_return(0)
      allow(cc_checker).to receive(:valid_luhn?).and_return(true)
      post users_payment_path,
           params: { card_number: 'a', expiration_date: '1111', billing_address: '1111', total_shards: 20,
                     cvv: '123' }
      expect(response).to redirect_to users_purchase_path
    end

    it 'updates user credits correctly' do
      cc_checker = instance_double(CreditCardDetector::Detector)
      allow(CreditCardDetector::Detector).to receive(:new).and_return(cc_checker)
      usr = instance_double(User)
      allow(User).to receive(:find_user_by_session_token).and_return(usr)
      allow(usr).to receive(:available_credits).and_return(0)
      allow(usr).to receive(:update).with({ available_credits: 20 }).and_return(0)
      allow(cc_checker).to receive(:valid_luhn?).and_return(true)
      post users_payment_path,
           params: { card_number: 'a', expiration_date: '1111', billing_address: '1111', total_shards: 20,
                     cvv: '123' }
      expect(response).to redirect_to users_purchase_path
    end
  end
end
# rubocop:enable Metrics/BlockLength
# rubocop:enable RSpec/ExampleLength
