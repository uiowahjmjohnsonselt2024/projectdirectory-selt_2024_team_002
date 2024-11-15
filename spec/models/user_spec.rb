require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'session token' do 
    it 'should generate a new session token on update token' do
      usr = User.new
      expect(SecureRandom).to receive(:hex)
      expect(usr).to receive(:save)
      usr.update_session_token
    end
  end
  describe 'find user methods' do

  end

  describe 'validationa' do

  end
end
