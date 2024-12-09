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
    
  end
end
