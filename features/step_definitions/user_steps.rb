When(/^I am on the Create Account page$/) do
  visit new_user_path
end

When(/^I am on the Login page$/) do
  visit users_login_path
end

# change to match the form fields
And(/^I fill in "([^"]*)" with "([^"]*)"$/) do |arg1, arg2|
  pending
end

And(/^I press "([^"]*)"$/) do |arg|
  click_button arg
end

Then(/^I should see "([^"]*)"$/) do |arg|
  expect(page).to have_content(arg)
end