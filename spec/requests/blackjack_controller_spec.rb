require 'rails_helper'

RSpec.describe BlackjackController, type: :request do
  let(:cur_user) { instance_double(User, id: 1, available_credits: 0) }
  let(:world) { instance_double(World, id: 1) }
  let(:user_world) { instance_double(UserWorld, user_row: 1, user_col: 1) }
  let(:gridsquare) { instance_double(Gridsquare, buy_in_amount: 100) }

  before do
    allow(User).to receive(:find_user_by_session_token).and_return(cur_user)
    allow(World).to receive(:find).and_return(world)
    allow(UserWorld).to receive(:find_by).and_return(user_world)
    allow(Gridsquare).to receive(:find_by_row_col).and_return(gridsquare)
    allow(cur_user).to receive(:charge_credits)
    allow(cur_user).to receive(:save).and_return(true)
    cookies[:session] = 'testtoken'
  end

  describe 'POST #update_user_credits' do
    context 'when result is win' do
      it 'adds credits to the user' do
        post update_user_credits_path, params: { result: 'win', world_id: world.id }
        expect(cur_user).to have_received(:charge_credits).with(-gridsquare.buy_in_amount)
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['shard_balance']).to eq(0)
      end
    end

    context 'when result is loss' do
      it 'deducts credits from the user' do
        post update_user_credits_path, params: { result: 'loss', world_id: world.id }
        expect(cur_user).to have_received(:charge_credits).with(gridsquare.buy_in_amount)
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['shard_balance']).to eq(0)
      end
    end

    context 'when result is invalid' do
      it 'redirects to the world path with an alert' do
        post update_user_credits_path, params: { result: 'invalid', world_id: world.id }
        expect(response).to redirect_to(world_path(world))
        expect(flash[:alert]).to eq('Invalid result')
      end
    end

    context 'when user is not authenticated' do
      before do
        allow(User).to receive(:find_user_by_session_token).and_return(nil)
      end

      it 'redirects to the login path with an alert' do
        post update_user_credits_path, params: { result: 'win', world_id: world.id }
        expect(response).to redirect_to(users_login_path)
        expect(flash[:alert]).to eq('Please login')
      end
    end
  end
end