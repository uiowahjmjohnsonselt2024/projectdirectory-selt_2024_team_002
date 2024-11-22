require 'money'
require 'money-open-exchange-rates'

# Helper for shards purchase and conversion
module ShardsHelper
  # returns the conversion rate between two currencies
  def conversion_rate(from_currency, to_currency)
    Money.default_bank = Money::Bank::OpenExchangeRatesBank.new
    Money.default_bank.app_id = '1d353fa9135d4277859f39c36e982496'
    Money.default_bank.update_rates
    conversion_rate = Money.default_bank.get_rate(from_currency, to_currency)
    puts conversion_rate
  end
end
