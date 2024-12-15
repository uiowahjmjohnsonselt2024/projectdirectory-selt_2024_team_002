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
      post send_reset_email_path, params: { email: 'admin@admin.com' }
      expect(response).to redirect_to forgot_password_path
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
      allow(User).to receive_messages(
        find_by: friend,
        find_user_by_session_token: usr
      )
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
      allow(usr).to receive_messages(
        available_credits: 0,
        update: 0
      )
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

  describe 'approve request' do
    before do
      usr = instance_double(User)
      allow(User).to receive(:find_user_by_session_token).and_return(usr)
      allow(usr).to receive(:id).and_return(1)
    end

    it 'has the appropriate message when the friend is found' do
      friend = instance_double(User)
      allow(friend).to receive_messages(
        id: 1,
        display_name: 'alex'
      )
      allow(User).to receive(:find_by).and_return(friend)
      fs = instance_double(Friendship)
      allow(fs).to receive(:update).and_return(true)
      allow(Friendship).to receive(:find_by).and_return(fs)
      post users_approve_request_path, params: { friend_id: 1 }
      expect(assigns(:message)).to eq('Friend accepted!')
    end

    it 'has the appropriate message when the friend not is found' do
      friend = instance_double(User)
      allow(friend).to receive_messages(
        id: 1,
        display_name: 'alex'
      )
      allow(User).to receive(:find_by).and_return(friend)
      fs = instance_double(Friendship)
      allow(fs).to receive(:update).and_return(false)
      allow(Friendship).to receive(:find_by).and_return(fs)
      post users_approve_request_path, params: { friend_id: 1 }
      expect(assigns(:message)).to eq('Friendship not found!')
    end

    it 'renders the correct template' do
      friend = instance_double(User)
      allow(friend).to receive_messages(
        id: 1,
        display_name: 'alex'
      )
      allow(User).to receive(:find_by).and_return(friend)
      fs = instance_double(Friendship)
      allow(fs).to receive(:update).and_return(false)
      allow(Friendship).to receive(:find_by).and_return(fs)
      post users_approve_request_path, params: { friend_id: 1 }
      expect(response).to render_template('approve_request')
    end
  end

  describe 'reject request' do
    let(:cur_user) { instance_double(User, id: 1) }
    let(:friend) { instance_double(User, id: 2) }
    let(:existing_friendship) { instance_double(Friendship, user_id: 1, friend_id: 2) }
    let(:inverse_friendship) { instance_double(Friendship, user_id: 2, friend_id: 1) }

    before do
      allow(User).to receive(:find_user_by_session_token).with(anything).and_return(cur_user)
      allow(User).to receive(:find_by).with(id: friend.id.to_s).and_return(friend)
    end

    describe 'when friendships exist' do
      before do
        allow(Friendship).to receive(:find_by).with(user_id: friend.id.to_s, friend_id: cur_user.id).and_return(existing_friendship)
        allow(Friendship).to receive(:find_by).with(user_id: cur_user.id, friend_id: friend.id.to_s).and_return(inverse_friendship)
        allow(existing_friendship).to receive(:destroy)
        allow(inverse_friendship).to receive(:destroy)
      end

      it 'destroys the existing friendship' do
        delete users_reject_request_path, params: { friend_id: friend.id }, xhr: true

        expect(existing_friendship).to have_received(:destroy)
        expect(inverse_friendship).to have_received(:destroy)
        expect(assigns(:message)).to eq('Friend request declined.')
      end
    end

    describe 'when only one direction of friendship exists' do
      it 'destroys only the existing friendship' do
        allow(Friendship).to receive(:find_by).with(user_id: cur_user.id, friend_id: friend.id.to_s).and_return(existing_friendship)
        allow(Friendship).to receive(:find_by).with(user_id: friend.id.to_s, friend_id: cur_user.id).and_return(nil)
        allow(existing_friendship).to receive(:destroy)

        delete users_reject_request_path, params: { friend_id: friend.id }, xhr: true

        expect(existing_friendship).to have_received(:destroy)
        expect(assigns(:message)).to eq('Friend request declined.')
      end

      it 'destroys only the inverse friendship' do
        allow(Friendship).to receive(:find_by).with(user_id: cur_user.id, friend_id: friend.id.to_s).and_return(nil)
        allow(Friendship).to receive(:find_by).with(user_id: friend.id.to_s, friend_id: cur_user.id).and_return(inverse_friendship)
        allow(inverse_friendship).to receive(:destroy)

        delete users_reject_request_path, params: { friend_id: friend.id }, xhr: true

        expect(inverse_friendship).to have_received(:destroy)
        expect(assigns(:message)).to eq('Friend request declined.')
      end
    end

    describe 'when no friendships exist' do
      it 'sets the correct message without destroying anything' do
        allow(Friendship).to receive(:find_by).and_return(nil)

        delete users_reject_request_path, params: { friend_id: friend.id }, xhr: true

        expect(assigns(:message)).to eq('Friend request declined.')
      end
    end
  end

  describe 'delete friend' do
    before do
      usr = instance_double(User)
      allow(User).to receive(:find_user_by_session_token).and_return(usr)
      allow(usr).to receive(:id).and_return(1)
    end

    it 'deletes the friendship' do
      friend = instance_double(User)
      allow(User).to receive(:find_by).and_return(friend)
      allow(friend).to receive(:id).and_return(1)
      fs = instance_double(Friendship)
      allow(Friendship).to receive(:find_by).and_return(fs)
      expect(fs).to receive(:destroy).twice
      delete users_delete_friend_path, params: { friend_id: 2 }
    end

    it 'renders the correct template' do
      friend = instance_double(User)
      allow(User).to receive(:find_by).and_return(friend)
      allow(friend).to receive(:id).and_return(1)
      fs = instance_double(Friendship)
      allow(Friendship).to receive(:find_by).and_return(fs)
      allow(fs).to receive(:destroy)
      delete users_delete_friend_path, params: { friend_id: 2 }
      expect(response).to render_template('delete_friend')
    end
  end

  # rubocop:disable RSpec/InstanceVariable
  describe 'add friend' do
    before do
      @usr = instance_double(User)
      allow(User).to receive(:find_user_by_session_token).and_return(@usr)
      allow(@usr).to receive(:id).and_return(1)
    end

    it 'has the correct message when the user isn\'t found' do
      allow(User).to receive(:find_by).and_return(nil)
      post users_add_friend_path, params: { friend_name: 'alex' }
      expect(assigns(:message)).to eq('User not found.')
    end

    it 'has the correct message when you add yourself as a friend' do
      allow(User).to receive(:find_by).and_return(@usr)
      post users_add_friend_path, params: { friend_name: 'alex' }
      expect(assigns(:message)).to eq('Unfortunately, you cannot add yourself as a friend.')
    end

    describe 'happy path' do
      it 'has saved successfully' do
        friend = instance_double(User)
        fs = instance_double(Friendship)
        allow(User).to receive(:find_by).and_return(friend)
        allow(friend).to receive(:id).and_return(1)
        allow(Friendship).to receive_messages(
          find_by: nil,
          new: fs
        )
        allow(fs).to receive(:save).and_return(true)

        post users_add_friend_path, params: { friend_name: 'alex' }
        expect(assigns(:message)).to eq('A friend request has been sent!')
      end

      it 'has didn\'t save' do
        friend = instance_double(User)
        fs = instance_double(Friendship)
        allow(User).to receive(:find_by).and_return(friend)
        allow(friend).to receive(:id).and_return(1)
        allow(Friendship).to receive_messages(
          find_by: nil,
          new: fs
        )
        allow(fs).to receive(:save).and_return(false)

        post users_add_friend_path, params: { friend_name: 'alex' }
        expect(assigns(:message)).to eq('Failed to add friendship.')
      end
    end
  end

  describe 'send invite' do
    let(:user) { instance_double(User, id: 0) }
    let(:friend) { instance_double(User, id: 1) }
    let(:world) { instance_double(World, id: 1, world_name: 'Fantasy World') }
    let(:invite) { instance_double(UserWorld, world: world, request: true) }

    before do
      allow(User).to receive(:find_user_by_session_token).and_return(user)
      allow(User).to receive(:find_by).with(hash_including(id: friend.id.to_s)).and_return(friend)
      allow(World).to receive(:find_by).with(id: world.id.to_s).and_return(world)
    end

    describe 'displays the correct message' do
      it 'when an invite has already been sent' do
        existing_request = double('UserWorld', request: true, world: world)
        allow(UserWorld).to receive(:find_by).with(user_id: friend.id, world_id: world.id, request: true).and_return(existing_request)
        allow(UserWorld).to receive(:find_by).with(user_id: friend.id, world_id: world.id, request: false).and_return(nil)
        allow(UserWorld).to receive(:new).with(user_id: friend.id, world_id: world.id, request: true).and_return(invite)

        post users_send_invite_path, params: { friend_id: friend.id.to_s, world_id: world.id.to_s }, xhr: true

        expect(assigns(:message)).to eq("An invite has already been sent for Fantasy World!")
      end

      it 'when the player has already accepted the invite' do
        existing_world = double('UserWorld', request: false, world: world)
        allow(UserWorld).to receive(:find_by).with(user_id: friend.id, world_id: world.id, request: false).and_return(existing_world)
        allow(UserWorld).to receive(:find_by).with(user_id: friend.id, world_id: world.id, request: true).and_return(nil)
        allow(UserWorld).to receive(:new).with(user_id: friend.id, world_id: world.id, request: true).and_return(invite)

        post users_send_invite_path, params: { friend_id: friend.id.to_s, world_id: world.id.to_s }, xhr: true

        expect(assigns(:message)).to eq("This player is already on Fantasy World!")
      end
    end

    describe 'saves' do
      it 'has saved successfully' do
        new_invite = double('UserWorld', save: true, world: world)
        allow(UserWorld).to receive(:new).and_return(new_invite)

        post users_send_invite_path, params: { friend_id: friend.id.to_s, world_id: world.id.to_s }, xhr: true

        expect(assigns(:message)).to eq("Invite sent!")
      end

      it 'did not save' do
        new_invite = double('UserWorld', save: false)
        allow(UserWorld).to receive(:new).and_return(new_invite)

        post users_send_invite_path, params: { friend_id: friend.id.to_s, world_id: world.id.to_s }, xhr: true

        expect(assigns(:message)).to eq("Failed to send world invite.")
      end
    end
  end

  describe 'approve_invite' do
    let(:cur_user) { instance_double(User, id: 1) }
    let(:world) { instance_double(World, id: 1, world_name: 'Fantasy World') }
    let(:invite) { instance_double(UserWorld, id: 1, user_id: user.id, world_id: world.id, request: true) }
    let(:user) { instance_double(User, id: 2) }

    before do
      allow(UserWorld).to receive(:find_by).with(user_id: user.id.to_s, world_id: world.id.to_s).and_return(invite)
    end

    it 'sets the correct message when invite is accepted' do
      allow(invite).to receive(:update).with(request: false).and_return(true)

      post users_approve_invite_path, params: { user_id: user.id, world_id: world.id }, xhr: true

      expect(assigns(:message)).to eq('Invite accepted!')
    end

    it 'sets the correct message when there is an error accepting invite' do
      allow(invite).to receive(:update).with(request: false).and_return(false)

      post users_approve_invite_path, params: { user_id: user.id, world_id: world.id }, xhr: true

      expect(assigns(:message)).to eq('Error accepting invite.')
    end
  end

  describe 'reject_invite' do
    let(:cur_user) { instance_double(User, id: 1) }
    let(:world) { instance_double(World, id: 1, world_name: 'Fantasy World') }
    let(:invite) { instance_double(UserWorld, id: 1, user_id: 2, world_id: world.id, request: true) }

    before do
      allow(User).to receive(:find_by).with(id: cur_user.id.to_s).and_return(cur_user)
      allow(World).to receive(:find_by_id).with(world.id).and_return(world)
      allow(UserWorld).to receive(:find_by).with(user_id: "2", world_id: world.id.to_s).and_return(invite)
    end

    it 'sets the correct message when invite is rejected' do
      allow(UserWorld).to receive(:delete).with(invite).and_return(true)

      delete users_reject_invite_path, params: { user_id: 2, world_id: world.id }, xhr: true

      expect(assigns(:message)).to eq('Invite rejected.')
    end

    it 'sets the correct message when there is an error rejecting invite' do
      allow(UserWorld).to receive(:delete).with(invite).and_return(false)

      delete users_reject_invite_path, params: { user_id: 2, world_id: world.id }, xhr: true

      expect(assigns(:message)).to eq('Error rejecting invite.')
    end
  end
end

  # rubocop:enable RSpec/InstanceVariable
# rubocop:enable Metrics/BlockLength
# rubocop:enable RSpec/ExampleLength
