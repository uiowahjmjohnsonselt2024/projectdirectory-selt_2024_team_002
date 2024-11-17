
Feature: Create account with user information
  As a user
  so I have an account to access the game

Scenario: Create account with non-unique display name
  When I am on the Create Account page
  And I fill in "Email:" with "test@test.com"
  And I fill in "Password:" with "admin"
  And I fill in "Confirm password:" with "FFFFaaasf@@#11"
  And I press the button "Create User"
  Then I should see "Username admin is taken"


Scenario: Create account with non matching password
  
Scenario: Create account with weak password

Scenario: Create account with invalid Email

Scenario: Create account with correct details
