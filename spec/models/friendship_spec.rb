# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Friendship, type: :model do
  describe 'init_if_not_inited' do
    it 'has friendship' do
      friend = described_class.new(friend_id: 1, user_id: 0, status: 'accepted')
      expect(friend).to have_attributes(friend_id: 1, user_id: 0, status: 'accepted')
    end
  end
end
