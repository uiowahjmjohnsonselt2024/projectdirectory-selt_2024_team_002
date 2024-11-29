# frozen_string_literal: true

require 'money'
require 'money/bank/open_exchange_rates_bank'

# Helper for shards purchase and conversion
module ShardsHelper
  # returns the conversion/price for a shard given a currency
  def self.get_shard_conversion(currency)
    Money.default_bank = Money::Bank::OpenExchangeRatesBank.new
    Money.default_bank.app_id = ENV['MONEY_APP_ID']

    rates = Money.default_bank.update_rates # gets most recent conversion rates relative to USD
    rates[currency]
  end
end
