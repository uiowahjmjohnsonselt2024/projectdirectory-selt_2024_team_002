Feature: Login in with user information
  As a user
  so that I can access the game home page

  Scenario: Login with nonexistent username
    When I am on the Login page
    And I fill in "Username:" with "test"
    And I fill in "Password:" with "test"
    And I press the button "Log In"
    Then I should see the exact phrase "Incorrect username and password"

  Scenario: Login with incorrect password
    When I am on the Login page
    And I fill in "Username:" with "test"
    And I fill in "Password:" with "test"
    And I press the button "Log In"
    Then I should see the exact phrase "Incorrect username and password"

  Scenario: Login with correct information
    When I am on the Login page
    And I fill in "Username:" with "admin"
    And I fill in "Password:" with "AdminsAreTheBest1$"
    And I press the button "Log In"
    Then I should be redirected to "/worlds"
