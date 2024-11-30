# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/VerifiedDoubles
# rubocop:disable RSpec/InstanceVariable
# rubocop:disable RSpec/ExampleLength
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

    it 'calles the orchestration module' do
      dummy_model = double('')
      allow(dummy_model).to receive(:empty?).and_return(true)
      allow(dummy_model).to receive(:create!)
      allow(@world).to receive(:gridsquares).and_return(dummy_model)
      expect(Concurrent::Future).to receive(:execute).exactly(4).times
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
# rubocop:enable RSpec/ExampleLength
# rubocop:enable RSpec/VerifiedDoubles
