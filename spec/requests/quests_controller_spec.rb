require 'rails_helper'

RSpec.describe QuestsController, type: :request do
  describe 'POST #complete_trivia' do
    let(:quest) { instance_double('Quest', world: instance_double('World')) } # Stub the world method

    before do
      allow(Quest).to receive(:find).and_return(quest)
    end

    context 'when the answer is correct' do
      before do
        allow(quest).to receive(:complete_trivia).and_return(true)
        post complete_trivia_quest_path(quest), params: { answer: 'correct_answer' }
      end

      it 'sets the flash notice' do
        expect(flash[:notice]).to eq('Correct answer! Quest completed.')
      end

      it 'redirects to the world path' do
        expect(response).to redirect_to(world_path(quest.world))
      end
    end

    context 'when the answer is incorrect' do
      before do
        allow(quest).to receive(:complete_trivia).and_return(false)
        post complete_trivia_quest_path(quest), params: { answer: 'wrong_answer' }
      end

      it 'sets the flash alert' do
        expect(flash[:alert]).to eq('Incorrect answer. Try again.')
      end

      it 'redirects to the world path' do
        expect(response).to redirect_to(world_path(quest.world))
      end
    end
  end

  describe 'POST #complete' do
    let(:quest) { instance_double('Quest', world: instance_double('World')) } # Stub the world method

    before do
      allow(Quest).to receive(:find).and_return(quest)
      allow(quest).to receive(:complete)
      post complete_quest_path(quest)
    end

    it 'calls the complete method on the quest' do
      expect(quest).to have_received(:complete)
    end

    it 'redirects to the world path' do
      expect(response).to redirect_to(world_path(quest.world))
    end
  end
end