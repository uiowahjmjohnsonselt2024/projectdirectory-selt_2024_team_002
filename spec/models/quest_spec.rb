# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Quest, type: :model do
 describe 'geerate movement' do
   it 'calls the necessary seems' do
     uw = instance_double(UserWorld)
     world = double('World')
     allow(uw).to receive(:world).and_return(world)
     gs = double('Gridsquare')
     img = double('img')
     expect(img).to receive(:attached?).and_return(true)
     expect(gs).to receive(:image).and_return(img)
     expect(gs).to receive(:row).and_return(0)
     expect(gs).to receive(:col).and_return(0)
     expect(world).to receive(:gridsquares).and_return([gs])
     expect(Quest).to receive(:create!)
     Quest.generate_movement_for(uw)
   end
 end
 describe 'geerate trivia' do
   
 end
 describe 'complete movement' do
   
 end
end
