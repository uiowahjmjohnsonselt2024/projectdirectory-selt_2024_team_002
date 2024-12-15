# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserWorld, type: :model do
  let(:user) { User.create!(display_name: 'Test User', email: 'test@test.com', password: 'Password123!') }
  let(:world) { World.create!(world_name: 'Test World', current_players: 0) }
  let(:user_world) { UserWorld.create!(user: user, world: world, xp: 0, seen: [[1, 1]], user_row: 1, user_col: 1) }

  describe 'free move' do
    it 'is not a free move if row diff > 1' do
      expect(described_class.free_move?(1, 3, 3, 3)).to be false
    end
    it 'is not a free move if col diff > 1' do
      expect(described_class.free_move?(1, 3, 1, 6)).to be false
    end
    it 'is not a free move if row diff > 1 and col_diff > 1' do
      expect(described_class.free_move?(1, 3, 4, 6)).to be false
    end

    it 'is a free move when its 1 to the left' do
      expect(described_class.free_move?(3, 3, 2, 3)).to be true
    end

    it 'is a free move when its 1 to the right' do
      expect(described_class.free_move?(3, 3, 4, 3)).to be true
    end

    it 'is a free move when its 1 up' do
      expect(described_class.free_move?(3, 3, 3, 2)).to be true
    end

    it 'is a free move when its 1 down' do
      expect(described_class.free_move?(3, 3, 3, 4)).to be true
    end
  end

  describe 'validations' do
    it 'is not valid when some seen row is out of range' do
      uw = described_class.new(xp: 0, seen: [[7, 2]])
      expect(uw).not_to be_valid
    end

    it 'is not valid when some seen col is out of range' do
      uw = described_class.new(xp: 0, seen: [[2, 7]])
      expect(uw).not_to be_valid
    end

    it 'is valid when both seen and col in range' do
      uw = described_class.new(xp: 0, seen: [[2, 2]])
      expect(uw).to be_valid
    end

    it 'is valid when both positions in range' do
      uw = described_class.new(user_row: 1, user_col: 1)
      expect(uw).to be_valid
    end

    it 'is not valid when row not in range' do
      uw = described_class.new(user_row: 500, user_col: 1)
      expect(uw).not_to be_valid
    end

    it 'is not valid when col not in range' do
      uw = described_class.new(user_row: 1, user_col: 100)
      expect(uw).not_to be_valid
    end
  end

  describe 'database finding' do
    it 'returns the first matching UserWorld' do
      # Create a mock of the UserWorld object returned by the query
      user_world = instance_double('UserWorld', user_id: 1, world_id: 1)
      allow(UserWorld).to receive(:where).with(user_id: 1, world_id: 1).and_return([user_world])
      allow([user_world]).to receive(:first).and_return(user_world)
      result = UserWorld.find_by_ids(1, 1)

      expect(result).to eq(user_world)
    end
  end

  describe 'move' do
    it 'calls the save method' do
      new = described_class.new
      allow(new).to receive(:save!)
      new.set_position(1, 3)
    end
  end

  describe 'item' do
    describe 'XP Boost' do
      it 'activates xp boost correctly' do
        user_world.boost_xp
        expect(user_world.xp_boost).to eq(1.25)
        expect(user_world.xp_boost_count).to eq(0)
      end

      it 'gives normal xp when boost is not active' do
        user_world.gain_xp(10)
        expect(user_world.xp).to eq(10)
      end

      it 'gives boosted xp and resets boost after 5 uses' do
        user_world.boost_xp
        5.times { user_world.gain_xp(10) }

        expect(user_world.xp).to eq((10 * 1.25).round * 5)
        expect(user_world.xp_boost).to eq(1)
        expect(user_world.xp_boost_count).to eq(0)
      end
    end

    describe 'Speed Boost' do
      it 'activates speed boost correctly' do
        user_world.use_speed_potion
        expect(user_world.speed_boost).to be true
        expect(user_world.speed_boost_count).to eq(0)
      end

      it 'disables speed boost after 3 updates' do
        user_world.use_speed_potion
        3.times { user_world.update_speed_count }

        expect(user_world.speed_boost).to be false
        expect(user_world.speed_boost_count).to eq(0)
      end
    end

    describe 'Luck Boost' do
      it 'activates luck boost correctly' do
        user_world.use_leaf_clover
        expect(user_world.luck_boost).to be true
        expect(user_world.luck_boost_count).to eq(0)
      end

      it 'disables luck boost after 5 updates' do
        user_world.use_leaf_clover
        5.times { user_world.update_luck_count }

        expect(user_world.luck_boost).to be false
        expect(user_world.luck_boost_count).to eq(0)
      end
    end
  end

  describe 'find_known_squares' do
    it 'returns the seen tiles for a user in a world' do
      user_world.save!
      expect(UserWorld.find_known_squares(user.id, world.id)).to eq([["1", "1"]])
    end
  end
end