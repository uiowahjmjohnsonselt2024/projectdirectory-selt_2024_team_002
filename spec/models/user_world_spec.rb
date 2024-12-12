require 'rails_helper'

RSpec.describe UserWorld, type: :model do
  describe 'free move' do
    it 'is not a free move if row diff > 1' do
      expect(described_class.free_move?(1,3,3,3)).to be false
    end
    it 'is not a free move if col diff > 1' do
      expect(described_class.free_move?(1,3,1,6)).to be false
    end
    it 'is not a free move if row diff > 1 and col_diff > 1' do
      expect(described_class.free_move?(1,3,4,6)).to be false
    end

    it 'is a free move when its 1 to the left' do
      expect(described_class.free_move?(3,3,2,3)).to be true
    end

    it 'is a free move when its 1 to the right' do
      expect(described_class.free_move?(3,3,4,3)).to be true
    end

    it 'is a free move when its 1 up' do
      expect(described_class.free_move?(3,3,3,2)).to be true
    end

    it 'is a free move when its 1 down' do
      expect(described_class.free_move?(3,3,3,4)).to be true
    end
  end
  
  describe 'validations' do
    it 'is not valid when some seen row is out of range' do
      uw = described_class.new(xp:0, seen: [[7,2]] )
      expect(uw).not_to be_valid
    end
    
    it 'is not valid when some seen col is out of range' do
      uw = described_class.new(xp:0, seen: [[2,7]] )
      expect(uw).not_to be_valid
    end
  
    it 'is valid when both seen and col in range' do
      uw = described_class.new(xp:0, seen: [[2,2]] )
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
      uw = described_class.new(user_row: 1, user_col: 100 )
      expect(uw).not_to be_valid
    end
  end

  describe 'move' do
    it 'calls the save method' do
      new = described_class.new
      allow(new).to receive(:save!)
      new.set_position(1,3)
    end
  end
end
