Feature: Quests
  As a user
  So I can complete quests and earn rewards

  @javascript
  Scenario: generate a movement quest
    Given I am logged in as a user
    And I have joined the world "Test World 1"
    When I click the button "Generate Movement Quest"
    Then I should see the exact phrase "Quest generated."
    And I should see a string that starts with "Move to"

  @javascript
  Scenario: generate a trivia quest
    Given I am logged in as a user
    And I have joined the world "Test World 1"
    When I click the button "Generate Trivia Quest"
    Then I should see the exact phrase "Quest generated."
    And I should see the exact phrase "Trivia Question"

  @javascript
  Scenario: complete a trivia quest with correct answer
    Given I am logged in as a user
    And I have joined the world "Test World 1"
    And a trivia quest is generated with the question "What is 2+2?" and answer "4"
    When I visit the quest page
    And I fill in "Answer" with "4"
    And I click the button "Submit Answer"
    Then I should see the exact phrase "Correct answer! Quest completed."

  @javascript
  Scenario: complete a trivia quest with incorrect answer
    Given I am logged in as a user
    And I have joined the world "Test World 1"
    And a trivia quest is generated with the question "What is 2+2?" and answer "4"
    When I visit the quest page
    And I fill in "Answer" with "3"
    And I click the button "Submit Answer"
    Then I should see the exact phrase "Incorrect answer."

  @javascript
  Scenario: view a quest
    Given I am logged in as a user
    And I have joined the world "Test World 1"
    When I visit the quest page
    Then I should see the exact phrase "Quest generated."
    And I should see a string that starts with "Move to" or "Trivia Question"