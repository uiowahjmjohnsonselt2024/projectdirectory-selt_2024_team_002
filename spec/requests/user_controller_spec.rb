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
end
# rubocop:enable Metrics/BlockLength
# rubocop:enable RSpec/ExampleLength
