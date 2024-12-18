# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe OpenaiWrapperHelper, type: :helper do
  before do
    WebMock.reset!
  end

  it 'does not attach anything when 3.5 turbo rate limit' do
    stub_request(:post, "https://api.openai.com/v1/chat/completions").to_return(body:"rate limit", status: 423)
    world = instance_double(World)
    event = instance_double(OpenaiEvent)
    expect(JSON).not_to receive(:parse)
    described_class.create_square(1,1,world,event)
  end

  it 'does not attach anything when DALLE rate limit' do
    stub_request(:post, "https://api.openai.com/v1/chat/completions").to_return(body: '{
        "choices": [
          {
            "message": {
              "content": "This is a test response content that needs to be parsed and stripped."
            }
          }
        ]
      }', status: 200)
    stub_request(:post, "https://api.openai.com/v1/images/generations").to_return(body:"rate limit", status: 423)
    world = instance_double(World)
    event = instance_double(OpenaiEvent)
    expect(world).not_to receive(:gridsquares)
    described_class.create_square(1,1,world,event)
  end

  it 'attaches correctly when all ok' do
    stub_request(:post, "https://api.openai.com/v1/chat/completions").to_return(body: '{
      "choices": [
        {
          "message": {
            "content": "This is a test response content that needs to be parsed and stripped."
          }
        }
      ]
    }', status: 200)
    stub_request(:post, "https://api.openai.com/v1/images/generations").to_return(body:'{
    "data": [
      {
    "url": "https://example.com/fake_dalle_image.jpg"
      }]}', status: 200)
    stub_request(:get, "https://example.com/fake_dalle_image.jpg").
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Host'=>'example.com',
          'User-Agent'=>'Ruby'
        }).
      to_return(status: 200, body: "", headers: {})

    world = double("world")
    allow(world).to receive(:id).and_return(1)
    event = instance_double(OpenaiEvent)
    gs = double('gridsquare')
    gs_instance = double('gs_instance')
    img = double('image')
    allow(world).to receive(:gridsquares).and_return(gs)
    allow(event).to receive(:destroy!)
    allow(gs).to receive(:where).and_return([gs_instance])
    allow(gs_instance).to receive(:image).and_return(img)
    allow(img).to receive(:attach)
    allow(gs_instance).to receive(:update).with(description: "This is a test response content that needs to be parsed and stripped.")
    described_class.create_square(1,1,world,event)
  end
end