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
    pending "add some examples (or delete) #{__FILE__}"
  end
  describe 'login page' do
    pending "add some examples (or delete) #{__FILE__}"
  end
  describe 'get-session' do
    pending "add some examples (or delete) #{__FILE__}"
  end
end
