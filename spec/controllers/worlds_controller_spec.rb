require 'spec_helper'
require 'rails_helper'

describe WorldsController do
  describe 'world page' do
    it 'should render the world page' do
      get "index"
      expect(response).to render_template('index')
    end
  end

  describe 'adding world' do
    it 'should select the Creating World template for rendering' do
      post :new
      expect(response).to render_template('new')
    end
    it 'should check the redirect back to home page' do
      post :add_world
      expect(response).to redirect_to worlds_path
    end
    it 'should call the model method that performs world creation' do
      fake_params = {:world_code => "11111", :world_name => "test", :user_id => "0", :is_public => true, :max_player => "5"}
      fake_results = World.new(fake_params)
      allow(World).to receive(:create).and_return(fake_results)
      post :add_world, fake_params
      expect(assigns(:world)).to eq(fake_results)
    end
  end
end
