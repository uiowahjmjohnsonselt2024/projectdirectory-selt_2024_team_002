Feature: move tiles
  As a user
  So I can move tiles

@javascript
Scenario: move tile enough credits
    When I log in with valid credentials
    And I click the button "Join" that is under the div with class name "Test_World_1"
    Then I should see the exact phrase "World Name: Test World 1"
    And I click on the last grid cell
    Then I should see a string that starts with "Are you sure you want to move to"
    And I press the button "Move!"
    Then I should not see the exact phrase "Insufficient credits!"

@javascript
Scenario: move tile broke boi
  When I am on the Create Account page
  And I create a user with email: "aguo2@uiowa.edu", username: "SKT T1 Faker", password: "FFFFaaasf@@#11"
  And I fill in "Username:" with "SKT T1 Faker"
  And I fill in "Password:" with "FFFFaaasf@@#11"
  And I press the button "Log In"
  Then I should be redirected to "/worlds"
  And I click the button "Join" that is under the div with class name "Test_World_1"
  Then I should see the exact phrase "World Name: Test World 1"
  And I click on the last grid cell
  Then I should see a string that starts with "Are you sure you want to move to"
  And I press the button "Move!"
  Then I should see the exact phrase "Insufficient credits!"
