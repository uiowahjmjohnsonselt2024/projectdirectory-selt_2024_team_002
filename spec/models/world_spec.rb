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
end
# rubocop:enable RSpec/InstanceVariable
