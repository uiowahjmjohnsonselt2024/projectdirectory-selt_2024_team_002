# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Friendship, type: :model do
  it 'can\'t add yourself as friend' do
    f = described_class.new
    f.user_id = 0
    f.friend_id = 0
    expect(f).not_to be_valid
  end
end
