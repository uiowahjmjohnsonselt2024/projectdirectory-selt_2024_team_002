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
  end
end
# rubocop:enable RSpec/InstanceVariable
