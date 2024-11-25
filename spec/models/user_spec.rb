# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe User, type: :model do
  describe 'session token' do
    it 'generates a new session token on update token' do
      usr = User.new
      expect(SecureRandom).to receive(:hex)
      expect(usr).to receive(:save)
      usr.update_session_token
    end
  end

  describe 'find user methods' do
    it 'finds the users by session token' do
      usr = double('user')
      expect(User).to receive(:where).with(['session_token = ?', 'eorihgerjgoajirgipo3j']).and_return([usr])
      expect(User.find_user_by_session_token('eorihgerjgoajirgipo3j')).to eq usr
    end

    it 'finds the user by display name' do
      usr = double('user')
      expect(User).to receive(:where).with(['display_name = ?', 'eorihgerjgoajirgipo3j']).and_return([usr])
      expect(User.find_user_by_display_name('eorihgerjgoajirgipo3j')).to eq usr
    end
  end

  describe 'validations' do
    # see the justification in the validation function
    describe 'password' do
      it 'dosent validate when the password is empty' do
        user = User.new(password: '')
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include("Password can't be blank")
      end

      it 'dosen\'t validate with length < 12' do
        user = User.new(password: '1aA#')
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Password must be longer than 12 characters')
      end

      it 'dosen\'t validate without a digit' do
        user = User.new(password: "asdASD!@\#$!\#")
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Password must include a digit')
      end

      it 'dosen\'t validate without an upper case letter' do
        user = User.new(password: "asdasd7!@\#$!\#")
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Password must include one uppercase letter')
      end

      it 'dosen\'t validate without a lower case letter' do
        user = User.new(password: "asdas2d!@\#$!\#")
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Password must include one uppercase letter')
      end

      it 'dosen\'t validate without a special character' do
        user = User.new(password: 'asdASD1234aads')
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Password must include one special character')
      end

      it 'is a valid password when all cases are met' do
        user = User.new(password: 'AlexGuo1234$')
        expect(user.errors[:password]).to eq []
      end
    end
    # display name and email validation are using prebuilt solutions
  end
end
# rubocop:enable Metrics/BlockLength
