# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/InstanceVariable
RSpec.describe World, type: :model do
  describe 'init_if_not_inited' do
    before do
      @world = described_class.new
    end

    it 'calls the initialize_grid if there are no gridcells' do
      allow(@world).to receive(:gridsquares).and_return([])
      allow(OpenaiWrapperHelper).to receive(:create_square)
      expect(@world).to receive(:initialize_grid)
      @world.init_if_not_inited
    end

    it 'does nothing if the world has been inited' do
      allow(@world).to receive(:gridsquares).and_return([1])
      expect(@world).not_to receive(:initialize_grid)
      @world.init_if_not_inited
    end

    it 'generates gridsquares on init' do
      gs = double("model")
      oaie = double("OpenaiEvent")
      allow(oaie).to receive(:save!)
      allow(OpenaiEvent).to receive(:new).and_return oaie
      times = World.dim() * World.dim
      expect(gs).to receive(:create!).exactly(times).times
      allow(gs).to receive(:empty?).and_return(true)
      allow(@world).to receive(:gridsquares).and_return(gs)
      @world.init_if_not_inited
    end

    it 'generates gridsquares on init' do
      gs = double("model")
      oaie = double("OpenaiEvent")
      allow(oaie).to receive(:save!)
      allow(OpenaiEvent).to receive(:new).and_return oaie
      allow(gs).to receive(:create!)
      allow(gs).to receive(:empty?).and_return(true)
      expect(OpenaiEvent).to receive(:new)
      allow(@world).to receive(:gridsquares).and_return(gs)
      @world.init_if_not_inited
    end
  end
  describe 'quests' do 
    it 'should return early if the join record is not found' do 
      world = described_class.new
      user = double('user')
      relation = double('rel')
      allow(user).to receive(:user_worlds).and_return(relation)
      allow(relation).to receive(:find_by).and_return(nil)
      expect(Kernel).to_not receive(:rand)
      world.generate_quest_for(user)
    end

    it 'should return early if the user has a quest' do 
      world = described_class.new
      join = double('join')
      user = double('user')
      relation = double('rel')
      quests = double('quests_rel')
      exists = double('exists')
      allow(user).to receive(:user_worlds).and_return(relation)
      allow(relation).to receive(:find_by).and_return(join)
      allow(join).to receive(:quests).and_return(quests)
      allow(quests).to receive(:where).and_return(exists)
      allow(exists).to receive(:exists?).and_return(true)
      expect(Quest).to_not receive(:generate_movement_for)
      expect(Quest).to_not receive(:generate_trivia_for)
      world.generate_quest_for(user)
    end
    
    it 'should generate a movement quest if the rand value is < 0.5' do 
      world = described_class.new
      join = double('join')
      user = double('user')
      relation = double('rel')
      quests = double('quests_rel')
      exists = double('exists')
      allow(user).to receive(:user_worlds).and_return(relation)
      allow(relation).to receive(:find_by).and_return(join)
      allow(join).to receive(:quests).and_return(quests)
      allow(quests).to receive(:where).and_return(exists)
      allow(exists).to receive(:exists?).and_return(false)
      allow(Kernel).to receive(:rand).and_return(0)
      expect(Quest).to receive(:generate_movement_for)
      expect(Quest).to_not receive(:generate_trivia_for)
      world.generate_quest_for(user)
    end


    it 'should generate a trivia quest if the rand value is > 0.5' do 
      world = described_class.new
      join = double('join')
      user = double('user')
      relation = double('rel')
      quests = double('quests_rel')
      exists = double('exists')
      allow(user).to receive(:user_worlds).and_return(relation)
      allow(relation).to receive(:find_by).and_return(join)
      allow(join).to receive(:quests).and_return(quests)
      allow(quests).to receive(:where).and_return(exists)
      allow(exists).to receive(:exists?).and_return(false)
      allow(Kernel).to receive(:rand).and_return(0.6)
      expect(Quest).to_not receive(:generate_movement_for)
      expect(Quest).to receive(:generate_trivia_for)
      world.generate_quest_for(user)
    end
  end
end
# rubocop:enable RSpec/InstanceVariable
