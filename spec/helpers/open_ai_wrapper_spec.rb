# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe OpenaiWrapperHelper, type: :helper do
  it 'does not attach anything when 3.5 turbo rate limit' do 
    stub_request(:post, "https://api.openai.com/v1/chat/completions").to_return(body: "abc", status: 423)
    
    world = instance_double(World)
    event = instance_double(OpenaiEvent)
    expect(JSON).not_to receive(:parse)
    described_class.create_square(1,1,world,event)
  end
  
end