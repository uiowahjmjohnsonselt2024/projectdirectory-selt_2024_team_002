# frozen_string_literal: true

And(/^I create a user with email: "([^"]*)", username: "([^"]*)", password: "([^"]*)"$/) do |email, username, password|
  # Fill in the form fields
  fill_in 'Email:', with: email
  fill_in 'Username:', with: username
  fill_in 'Password:', with: password
  fill_in 'Confirm Password:', with: password

  # Press the Sign Up button
  click_button 'Sign Up'

  # Verify redirection and success message
  expect(page).to have_current_path('/users/login')
  expect(page).to have_content('Account created successfully')
end

When(/^I am on the Create Account page$/) do
  visit new_user_path
end

When(/^I am on the Login page$/) do
  visit users_login_path
end

When(/^I am on the Reset Password page$/) do
  visit reset_password_path
end

When(/^I am on the home page$/) do
  visit '/'
end

# change to match the form fields
And(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field_name, value|
  fill_in field_name, with: value
end

# CAREFULL! some links look like buttons, make sure to inspect element
And(/^I press the link "([^"]*)"$/) do |arg|
  click_link arg
end

And(/^I press the button "([^"]*)"$/) do |arg|
  click_button arg
end

Then(/^I should see the exact phrase "([^"]*)"$/) do |arg|
  expect(page).to have_content(arg)
end

Then(/^I should see a string that starts with "([^"]*)"$/) do |arg|
  expect(page).to have_content(/^#{Regexp.escape(arg)}/)
end

Then(/^I should be redirected to "([^"]*)"$/) do |arg|
  current_url_path = URI.parse(current_url).path
  expect(current_url_path).to eq(arg)
  expect(page).to have_current_path(arg, ignore_query: true) # assuming your dashboard path is called dashboard_path
end
