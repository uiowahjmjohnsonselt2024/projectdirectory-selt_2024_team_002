# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe ShardsHelper, type: :helper do
  describe 'get_shard_conversion' do
    it 'updates the conversion rates when called' do
      bank = instance_double(Money::Bank::OpenExchangeRatesBank)
      allow(Money::Bank::OpenExchangeRatesBank).to receive(:new).and_return(bank)
      expect(bank).to receive(:update_rates).and_return({USD: 1})
      allow(bank).to receive(:app_id=)
      described_class.get_shard_conversion("USD")
    end
    it 'updates the conversion rates when called' do
      bank = instance_double(Money::Bank::OpenExchangeRatesBank)
      allow(Money::Bank::OpenExchangeRatesBank).to receive(:new).and_return(bank)
      allow(bank).to receive(:update_rates).and_return({USD: 1})
      allow(bank).to receive(:app_id=)
      expect(described_class.get_shard_conversion(:USD)).to eq(1)
    end
  end
end