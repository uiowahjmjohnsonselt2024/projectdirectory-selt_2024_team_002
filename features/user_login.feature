Feature: Login in with user information
  As a user
  So that I can access the game home page

  Scenario: Login with nonexistent username
    When I am on the Login page
    And I fill in "Username:" with "test"
    And I fill in "Password:" with "test"
    And I press the button "Log In"
    Then I should see the exact phrase "Incorrect username or password"

  Scenario: Login with incorrect password
    When I am on the Login page
    And I fill in "Username:" with "test"
    And I fill in "Password:" with "test"
    And I press the button "Log In"
    Then I should see the exact phrase "Incorrect username or password"

  Scenario: Login with correct information
    When I am on the Login page
    And I fill in "Username:" with "admin"
    And I fill in "Password:" with "AdminsAreTheBest1$"
    And I press the button "Log In"
    Then I should be redirected to "/worlds"

  Scenario: Visiting login when logged in
    When I am on the Login page
    And I fill in "Username:" with "admin"
    And I fill in "Password:" with "AdminsAreTheBest1$"
    And I press the button "Log In"
    Then I should be redirected to "/worlds"
    And I am on the Login page
    Then I should be redirected to "/worlds"