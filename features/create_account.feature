Feature: Create account with user information
  as a user
  so I have an account to access the game

Scenario: Create account with non-unique display name
  When I am on the Create Account page
  And I fill in "First Name" with "test"
  And I fill in "Last Name" with "test"
  And I fill in "email" with "test@test.com"
  And I fill in "Password" with "test"
  And I fill in "Confirm password" with "test"
  And I press "Create User"
  Then I should see "The username test already exists"


Scenario: Create account with unique username
  When I am on the Create Account page
  And I fill in "First Name" with "test"
  And I fill in "Last Name" with "test"
  And I fill in "email" with "test@test.com"
  And I fill in "Password" with "test"
  And I fill in "Confirm password" with "test"
  And I press "Create User"
  Then I should see "Account created successfully"

