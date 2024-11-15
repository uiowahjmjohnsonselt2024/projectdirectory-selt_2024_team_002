# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Users', type: :request do
  describe 'create account page' do
    it 'should render the create account page' do 
      get new_user_path
      expect(response).to render_template('new')
    end
  end
  describe 'create user' do
    it 'should redirect to new_user_path if the password confirmation doesn\'t match' do
      post users_path, {:user => {:password => 'hello', :password_confirmation => 'password_confirmation'}}
      expect(response).to redirect_to new_user_path
    end
    it 'should redirect to new_user_path if user inputs invalid data' do
      usr = double('user')
      allow(User).to receive(:new).and_return(usr)
      allow(usr).to receive(:valid?).and_return(false)
      errors = double('errors')
      allow(usr).to receive(:errors).and_return(errors)
      allow(errors).to receive(:empty?).and_return(false)
      allow(errors).to receive(:full_messages).and_return(['Password can\'t be blank'])
      post users_path, {:user => {:password => 'hello', :password_confirmation => 'password_confirmation'}} # no display name or email
      expect(response).to redirect_to new_user_path
    end
    it 'should redirect to new_user_path if the save fails' do
      usr = double('user')
      allow(User).to receive(:new).and_return(usr)
      allow(usr).to receive(:valid?).and_return(true)
      allow(usr).to receive(:save).and_return(false)
      errors = double('errors')
      allow(usr).to receive(:errors).and_return(errors)
      allow(errors).to receive(:empty?).and_return(true)
      post users_path, {:user => {:password => 'J&Jwuth2throsumMo', :password_confirmation => 'J&Jwuth2throsumMo', :user_name => "alex", :email => "aguo2@uiowa.edu"}}
      expect(response).to redirect_to new_user_path	
    end
    it 'redirect to the login page if the user is created successfully' do
      usr = double('user')
      allow(User).to receive(:new).and_return(usr)
      expect(usr).to receive(:valid?).and_return(true)
      expect(usr).to receive(:save).and_return(true)
      post users_path, {:user => {:password => 'J&Jwuth2throsumMo', :password_confirmation => 'J&Jwuth2throsumMo', :user_name => "alex", :email => "aguo2@uiowa.edu"}}
      expect(response).to redirect_to users_login_path	
    end
    
  end
  describe 'login page' do
    it 'should render the login page' do 
      get users_login_path	
      expect(response).to render_template('login')
    end
  end
  describe 'get-session' do
    pending "add some examples (or delete) #{__FILE__}"
  end
end
