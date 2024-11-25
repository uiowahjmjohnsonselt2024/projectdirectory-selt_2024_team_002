# frozen_string_literal: true

require 'rails_helper'

RSpec.describe World, type: :model do
  describe 'get_grids' do 
    it 'should call the necessary seam' do 
      @world = World.new()
      expect(@world).to receive(:gridsquares).and_return([])
      @world.get_grids()
    end
  end
  describe 'init_if_not_inited' do
    before(:each) do
      @world = World.new()
    end
    it 'should call the initialize_grid if there are no gridcells' do 
      expect(@world).to receive(:gridsquares).and_return([])
      expect(@world).to receive(:initialize_grid)
      @world.init_if_not_inited()
    end
    it 'should do nothing if the world has been inited' do
      expect(@world).to receive(:gridsquares).and_return([1])
      expect(@world).not_to receive(:initialize_grid)
      @world.init_if_not_inited()
    end
  end
end
