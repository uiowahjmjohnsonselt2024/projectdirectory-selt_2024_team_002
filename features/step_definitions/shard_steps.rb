require 'app/helpers/shards_helper'

Given(/^I am on the purchase shards page$/) do
  visit users_purchase_path
end

When(/^I purchase shards with (\d+) "([^"]*)"$/) do |amount, currency|
  @user_shards = @user.available_credits
  @shard_price = get_shard_conversion(currency)
  @shards_bought = amount * @shard_price
end

# check if the users shards has increased by @total_shards
Then(/^I should have the correct amount of shards$/) do
  expect(page).to have_content(@user_shards + @shards_bought)
end
