Feature: create account with user information

  as a user
  so I have an account to access the game

Scenario: create account with non-unique display name
  When I am on the create account page
  And I fill in "First Name" with "test"
  And I fill in "Last Name" with "test"
  And I fill in "email" with "test@test.com"
  And I fill in "Password" with "test"
  And I fill in "Confirm password" with "test"
  And I press "Create User"
  Then I should see "The username test already exists"


Scenario: create account with unique username
  When I am on the create account page#  And I fill in "display name" with "user2"
  And I fill in "email" with "
  And I fill in "password" with "password"
  And I fill in "confirm password" with "password"
  And I press "Create Account"
  Then I should see "Account created successfully"

