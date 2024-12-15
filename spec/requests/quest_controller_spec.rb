# spec/controllers/quests_controller_spec.rb
require 'rails_helper'

RSpec.describe QuestsController, type: :controller do
  let(:user) { instance_double(User, id: 1) }
  let(:user_world) { instance_double(UserWorld, id: 1, world: world, quests: quests) }
  let(:world) { instance_double(World, id: 1) }
  let(:quest) { instance_double(Quest, id: 1, world: world) }
  let(:quests) { double('quests_relation') }

  before do
    allow(User).to receive(:find_user_by_session_token).and_return(user)
    allow(UserWorld).to receive(:find_by_ids).and_return(user_world)
    allow(quests).to receive(:where).with(completed: false).and_return([quest])
    allow(Quest).to receive(:find).with('1').and_return(quest)
    allow(Quest).to receive(:random_quest_message).and_return('Random message')
    allow(quest).to receive(:completed)
    allow(quest).to receive(:complete_trivia)
    allow(quest).to receive(:move_quest?)
  end

  describe 'POST #complete' do
    it 'sets flash notice and redirects to world path when quest is completed' do
      allow(quest).to receive(:completed).and_return(true)
      post :complete, params: { id: 1 }
      expect(flash[:notice]).to eq('Quest completed.')
      expect(response).to redirect_to(world_path(world))
    end

    it 'sets flash alert and redirects to world path when quest is not completed' do
      allow(quest).to receive(:completed).and_return(false)
      post :complete, params: { id: 1 }
      expect(flash[:alert]).to eq('Quest not completed.')
      expect(response).to redirect_to(world_path(world))
    end
  end

  describe 'POST #complete_trivia' do
    it 'sets flash notice and redirects to world path when trivia answer is correct' do
      allow(quest).to receive(:complete_trivia).with('correct_answer').and_return(true)
      post :complete_trivia, params: { id: 1, answer: 'correct_answer' }
      expect(flash[:alert]).to eq('Correct answer! Quest completed.')
      expect(response).to redirect_to(world_path(world))
    end

    it 'sets flash alert and redirects to world path when trivia answer is incorrect' do
      allow(quest).to receive(:complete_trivia).with('wrong_answer').and_return(false)
      post :complete_trivia, params: { id: 1, answer: 'wrong_answer' }
      expect(flash[:alert]).to eq('Incorrect answer.')
      expect(response).to redirect_to(world_path(world))
    end
  end

  describe 'GET #quest' do
    it 'generates a new quest if no incomplete quests are found' do
      allow(quests).to receive(:where).with(completed: false).and_return([])
      expect(user_world).to receive(:quests).and_return(quests).exactly(3).times
      expect(world).to receive(:generate_quest_for).with(user)
      get :quest, params: { world_id: 1 }
      expect(flash[:notice]).to eq('Quest generated.')
    end

    it 'sets @quest and @quests' do
      get :quest, params: { world_id: 1 }
      expect(assigns(:quest)).to eq(quest)
      expect(assigns(:quests)).to eq(quests)
    end

    it 'sets @random_quest_message if @quest is a move quest' do
      allow(quest).to receive(:move_quest?).and_return(true)
      get :quest, params: { world_id: 1 }
      expect(assigns(:random_quest_message)).to eq('Random message')
    end

    it 'responds to js format' do
      request.headers['Accept'] = 'application/javascript'
      get :quest, params: { world_id: 1 }, format: :js
      expect(response.content_type).to include 'text/javascript'
    end
  end
end