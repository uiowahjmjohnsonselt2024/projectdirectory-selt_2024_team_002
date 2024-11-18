# frozen_string_literal: true

When(/^I am on the Creation World page$/) do
  visit new_world_path
end

# rubocop:disable Layout/LineLength
When(/^I enter the fields with world name "([^"]*)", world code "([^"]*)", public is "([^"]*)", and max player to be "([^"]*)"$/) do |arg1, arg2, arg3, arg4|
  # rubocop:enable Layout/LineLength
  fill_in 'World Name:', with: arg1
  fill_in 'World Code:', with: arg2
  case arg3
  when 'public'
    choose 'is_public'
  when 'private'
    choose 'is_private'
  end
  fill_in 'max_player', with: arg4
end

When(/^I submit the "([^"]*)" form$/) do |button_name|
  click_button button_name
end

# rubocop:disable Layout/LineLength
Then(/^I should see a world list entry in the "([^"]*)" tab with world name "([^"]*)" and world code "([^"]*)"$/) do |arg1, arg2, arg3|
  # rubocop:enable Layout/LineLength
  visit worlds_path
  case arg1
  when 'public'
    click_button 'Public Worlds'
  when 'private'
    click_button 'Private Worlds'
  end
  expect(page).to have_content(arg2)
  expect(page).to have_content(arg3)
end

When(/^I am on the World Homepage$/) do
  visit worlds_path
end

When(/^I click on the "([^"]*)" tab$/) do |tab_name|
  click_on tab_name
end

Then(/^I should see either the text "([^"]*)" or a list entry with "([^"]*)" and "([^"]*)"$/) do |empty, uid, name|
  if page.has_content?(empty)
    expect(page).to have_content(empty)
  else
    expect(page).to have_content(uid)
    expect(page).to have_content(name)
  end
end

When(/^I log in with valid credentials$/) do
  visit users_login_path
  steps 'And I fill in "Username:" with "admin"'
  steps 'And I fill in "Password:" with "AdminsAreTheBest1$"'
  steps 'And I press the button "Log In"'
  steps 'Then I should be redirected to "/worlds"'
end
