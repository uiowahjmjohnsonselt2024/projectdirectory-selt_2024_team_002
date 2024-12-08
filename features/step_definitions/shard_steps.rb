# frozen_string_literal: true

Given(/^I am on the purchase shards page$/) do
  visit users_purchase_path
end

When(/^I fill in "([^"]*)" with (\d+) and currency "([^"]*)"$/) do |field, shards, currency|
  fill_in field, with: shards.to_i
  within '#dropdown-content' do
    click_button currency
  end
end

When(/^I submit the Proceed to Checkout form for shards$/) do
  find('input:nth-child(5)').click
  visit users_checkout_path
end

Then(/^I should see the content of "([^"]*)" be "([^"]*)" and "([^"]*)" be "([^"]*)"$/) do |text1, price, text2, total|
  expect(page).to have_content text1
  expect(page).to have_content price
  expect(page).to have_content text2
  expect(page).to have_content total
end

Then(/^I should have the correct amount of shards$/) do
  expect(page).to have_content(0)
end
