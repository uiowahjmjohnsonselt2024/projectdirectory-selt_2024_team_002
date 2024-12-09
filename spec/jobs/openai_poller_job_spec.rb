require 'rails_helper'

RSpec.describe OpenaiPollerJob, type: :job do
  it 'finds the correct world' do
    job = instance_double(OpenaiEvent)
    allow(job).to receive(:world_id).and_return(1)
    allow(job).to receive(:row).and_return(1)
    allow(job).to receive(:col).and_return(1)
    allow(OpenaiEvent).to receive(:limit).and_return([job])
    allow(World).to receive(:where).and_return([])
    expect(World).to receive(:where)
    described_class.perform_now
  end

  it 'runs a promise' do
    job = instance_double(OpenaiEvent)
    allow(job).to receive(:world_id).and_return(1)
    allow(job).to receive(:row).and_return(1)
    allow(job).to receive(:col).and_return(1)
    allow(OpenaiEvent).to receive(:limit).and_return([job])
    allow(World).to receive(:where).and_return([])
    expect(Concurrent::Promises).to receive(:future)
    described_class.perform_now
  end

end
