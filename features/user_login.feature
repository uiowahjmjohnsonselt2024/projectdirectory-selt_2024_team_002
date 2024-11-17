Feature: Login in with user information
  As a user
  so that I can access the game home page

  Scenario: Login with nonexistent username
    When I am on the Login page
    And I fill in "Username" with "test"
    And I fill in "Password" with "test"
    And I press "Login"
    Then I should see "User with username test does not exist"

  Scenario: Login with incorrect password
    When I am on the Login page
    And I fill in "Username" with "test"
    And I fill in "Password" with "test"
    And I press "Login"
    Then I should see "Incorrect password"

  Scenario: Login with correct information
    When I am on the Login page
    And I fill in "Username" with "test"
    And I fill in "Password" with "test"
    And I press "Login"
    Then I should see "Login successful"