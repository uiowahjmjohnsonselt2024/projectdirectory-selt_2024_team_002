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
 describe 'generate trivia' do
   it 'calls the create function' do
    uw = instance_double(UserWorld)
    world = double('World')
    allow(uw).to receive(:world).and_return(world)
    expect(Quest).to receive(:create!)
    Quest.generate_trivia_for(uw)
   end
 end

 describe 'complete trivia' do
  it 'dosent change exp on wrong answer' do
    quest = described_class.new
    uw = instance_double(UserWorld)
    allow(quest).to receive(:trivia_question).and_return({answer: 'ship'})
    allow(quest).to receive(:update!)
    expect(uw).to_not receive(:increment)
    allow(quest).to receive(:user_world).and_return(uw)
    expect(quest).to receive(:update!)
    quest.complete_trivia('bob')
  end 

  it 'does change exp on wrong answer' do
    quest = described_class.new
    uw = instance_double(UserWorld)
    allow(quest).to receive(:trivia_question).and_return({'answer' => 'ship'})
    allow(quest).to receive(:update!)
    expect(uw).to receive(:increment).and_return(uw)
    expect(uw).to receive(:save!)
    usr = instance_double(User)
    expect(uw).to receive(:user).and_return(usr)
    expect(usr).to receive(:increment).and_return(usr)
    expect(usr).to receive(:save!)
    allow(quest).to receive(:user_world).and_return(uw)
    expect(quest).to receive(:update!)
    quest.complete_trivia('ship')
  end 

 end

 describe 'complete movement' do
   it 'increments at the correct location' do
     uw = instance_double(UserWorld)
     quest = instance_double(Quest)
     q = double('questrelation')
     flash = {}
     allow(uw).to receive(:quests).and_return(q)
     allow(q).to receive(:find_by).and_return(quest)
     allow(quest).to receive(:complete_movement)
     allow(quest).to receive(:cell_row).and_return(1)
     allow(quest).to receive(:cell_col).and_return(1)
     Quest.check_and_complete_movement_quest(uw, 1, 1, flash)
   end

   it 'does not increment at the incorrect location' do
     uw = instance_double(UserWorld)
     quest = instance_double(Quest)
     q = double('questrelation')
     flash = {}
     allow(uw).to receive(:quests).and_return(q)
     allow(q).to receive(:find_by).and_return(quest)
     allow(quest).to receive(:complete_movement)
     allow(quest).to receive(:cell_row).and_return(1)
     allow(quest).to receive(:cell_col).and_return(1)
     result = Quest.check_and_complete_movement_quest(uw, 2, 1, flash)
     expect(result).to be false
   end
 end

 describe 'complete movement' do
   it 'increments the correct things' do
     q = described_class.new
     uw = instance_double(UserWorld)
     usr = instance_double(User)
     flash = {}
     expect(q).to receive(:user_world).and_return(uw).exactly(2).times
     expect(uw).to receive(:user).and_return(usr)
     expect(usr).to receive(:save!).exactly(2).times
     expect(usr).to receive(:increment).and_return(usr)
     expect(uw).to receive(:increment).and_return(usr)
     q.complete_movement(flash)
     expect(flash[:alert]).to eq('Quest completed.')
   end
 end

end
