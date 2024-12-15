require 'rails_helper'

RSpec.describe BlackjackController, type: :request do
  let(:cur_user) { instance_double(User, id: 1, available_credits: 1000) }
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
    allow(user_world).to receive(:luck_boost).and_return(true) # Stub the luck_boost method
    allow(user_world).to receive(:update_luck_count) # Stub the update_luck_count method
    cookies[:session] = 'testtoken'
  end

  describe 'POST #update_user_credits' do
    context 'when result is win' do
      it 'adds credits to the user' do
        expect(cur_user).to receive(:charge_credits).with(-2 * gridsquare.buy_in_amount)
        post update_user_credits_path, params: { result: 'win', world_id: world.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['shard_balance']).to eq(cur_user.available_credits)
      end
    end

    context 'when result is buy_in' do
      it 'deducts credits from the user' do
        expect(cur_user).to receive(:charge_credits).with(gridsquare.buy_in_amount)
        post update_user_credits_path, params: { result: 'buy_in', world_id: world.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['shard_balance']).to eq(cur_user.available_credits)
      end
    end

    context 'when result is push' do
      it 'refunds the buy-in amount to the user' do
        expect(cur_user).to receive(:charge_credits).with(-gridsquare.buy_in_amount)
        post update_user_credits_path, params: { result: 'push', world_id: world.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['shard_balance']).to eq(cur_user.available_credits)
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