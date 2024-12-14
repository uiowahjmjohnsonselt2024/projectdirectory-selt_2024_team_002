# frozen_string_literal: true

Given(/^I am on the purchase shards page$/) do
  visit users_purchase_path
end

When(/^I fill in "([^"]*)" with (\d+) and currency "([^"]*)"$/) do |field, shards, currency|
  fill_in field, with: shards.to_i
  find('#currency').hover
  within '#dropdown-content' do
    click_button currency
  end
end

When(/^I submit the Proceed to Checkout form for shards$/) do
  find('input:nth-child(5)').click
  visit users_checkout_path
end

Then('I click on the last grid cell') do
  # Click on the last grid cell in the array of grid cells
  all('.grid_cell').last.click
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

And('I wait for {int} seconds') do |seconds|
  sleep(seconds)
end

Given('I hover over the element with {string}') do |selector|
  find(selector).hover
end

When(/^I click on the "([^"]*)" button$/) do |button|
  click_button button
end

When(/^I press the button "([^"]*)" to increase or decrease amount$/) do |button|
  if button == '+'
    first('#plus_button_0').click
  else
    first('#minus_button_0').click
  end
end

Then(/^I should see my shard decrease from "([^"]*)" shards$/) do |previous_shard|
  within('#shard_blob') do
    shard_content = find('#shard_number').text
    shard_number = shard_content.to_i
    expect(shard_number).to be < previous_shard.to_i
  end
end

When(/^I press the button "([^"]*)" on index "([^"]*)" to increase or decrease amount$/) do |button, index|
  if button == '+'
    find("#plus_button_#{index}").click
  else
    find("#minus_button_#{index}").click
  end
end
