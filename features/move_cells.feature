Feature: move tiles
  As a user
  So I can move tiles

@javascript
Scenario: move tile 
    When I log in with valid credentials
    And I click the button "Join" that is under the div with class name "Test_World_1"
    Then I should see the exact phrase "World Name: Test World 1"
    # And I click on the last grid cell
