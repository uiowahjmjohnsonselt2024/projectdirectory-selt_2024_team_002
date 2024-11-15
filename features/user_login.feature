Feature: login in with user information

  as a user
  so that I can access the game home page

Scenario: login with nonexistent username
  When I am on the login page
  And I fill in "Username" with "test"
  And I fill in "Password" with "test"
  And I press "Login"
  Then I should see "User with username test does not exist"

Scenario: login with incorrect password
  When I am on the login page
  And I fill in "Username" with "test"
  And I fill in "Password" with "test"
  And I press "Login"
  Then I should see "Incorrect password"