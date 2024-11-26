require 'money'
require 'money/bank/open_exchange_rates_bank'

# Helper for shards purchase and conversion
module ShardsHelper
  # returns the conversion/price for a shard given a currency
  def self.get_shard_conversion(currency)
    Money.default_bank = Money::Bank::OpenExchangeRatesBank.new
    Money.default_bank.app_id = '1d353fa9135d4277859f39c36e982496'

    rates = Money.default_bank.update_rates # gets most recent conversion rates relative to USD
    rates[currency]
  end
end
