# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe User, type: :model do
  describe 'session token' do
    it 'generates a new session token on update token' do
      usr = described_class.new
      expect(SecureRandom).to receive(:hex)
      usr.update_session_token
    end
  end

  describe 'find user methods' do
    it 'finds the users by session token' do
      usr = instance_double(described_class)
      allow(described_class).to receive(:where).with(['session_token = ?', 'eorihgerjgoajirgipo3j']).and_return([usr])
      expect(described_class.find_user_by_session_token('eorihgerjgoajirgipo3j')).to eq usr
    end

    it 'finds the user by display name' do
      usr = instance_double(described_class)
      allow(described_class).to receive(:where).with(['display_name = ?', 'eorihgerjgoajirgipo3j']).and_return([usr])
      expect(described_class.find_user_by_display_name('eorihgerjgoajirgipo3j')).to eq usr
    end
  end

  describe 'validations' do
    # see the justification in the validation function

    # rubocop:disable RSpec/MultipleExpectations
    describe 'password' do
      it 'dosent validate when the password is empty' do
        user = described_class.new(password: '')
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include("Password can't be blank")
      end

      it 'dosen\'t validate with length < 12' do
        user = described_class.new(password: '1aA#')
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Password must be longer than 12 characters')
      end

      it 'dosen\'t validate without a digit' do
        user = described_class.new(password: "asdASD!@\#$!\#")
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Password must include a digit')
      end

      it 'dosen\'t validate without an upper case letter' do
        user = described_class.new(password: "asdasd7!@\#$!\#")
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Password must include one uppercase letter')
      end

      it 'dosen\'t validate without a lower case letter' do
        user = described_class.new(password: "asdas2d!@\#$!\#")
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Password must include one uppercase letter')
      end

      it 'dosen\'t validate without a special character' do
        user = described_class.new(password: 'asdASD1234aads')
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Password must include one special character')
      end

      it 'is a valid password when all cases are met' do
        user = described_class.new(password: 'AlexGuo1234$')
        expect(user.errors[:password]).to eq []
      end
    end
    # rubocop:enable RSpec/MultipleExpectations
    # display name and email validation are using prebuilt solutions
  end

  describe 'shards' do
    it 'has available shard to be 0 when newly created' do
      user = described_class.new
      expect(user).to have_attributes(available_credits: 0)
    end
  end

  describe 'purchase plus' do
    it 'correctly deduct balance when purchasing plus' do
      usr = described_class.new(available_credits: 1000)
      allow(usr).to receive(:save)
      usr.purchase_plus_user
      expect(usr.available_credits).to eq 900
    end

    it 'correctly upgrade the user' do
      usr = described_class.new(available_credits: 1000)
      allow(usr).to receive(:save)
      usr.purchase_plus_user
      expect(usr.plus_user).to be true
    end
  end
end
# rubocop:enable Metrics/BlockLength
