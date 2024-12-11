# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'quests', type: :request do
  describe 'not logged in' do
    it 'redirects correctly if the user is not logged in' do
      allow(User).to receive(:find_user_by_session_token).and_return(nil)
      post generate_quests_path	
      # expect(response).to redirect_to users_login_path
    end
  end
  
  describe 'logged in' do
    before do 
      usr = instance_double(User)
      allow(User).to receive(:find_user_by_session_token).and_return(usr)
      allow(usr).to receive(:id).and_return(1)
    end
    
    it 'calls the complete quest method for the complete route' do
      
    end

    it 'redirects to the world path for the complete route' do
      
    end

    it 'calls the complete trivia model method for complete trivia route' do 
      
    end

    it 'redirects to the world path for complete trivia route' do 
      
    end
  
    it 'finds the quest for the show route' do
      
    end

    it 'calls the generate quest for the generate route' do
      
    end
  end
end
# rubocop:enable RSpec/InstanceVariable
# rubocop:enable Metrics/BlockLength
# rubocop:enable RSpec/ExampleLength
