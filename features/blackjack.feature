Feature: Play the mini game blackjack
  As a user,
  So I can gain more shards

  @javascript
  Scenario: I get a blackjack and I win
    When I log in with valid credentials
    And I click the button "Join" that is under the div with class name "Test_World_1"
    Then I should see the exact phrase "World Name: Test World 1"
    And I press the button "Gamble"
    Then I should see the exact phrase "Blackjack"
    And I press the button "Play"
    And I have a blackjack and the dealer does not
    Then I should see the exact phrase "Player Blackjack! Player Wins!"

  @javascript
  Scenario: The dealer gets a blackjack and I lose
    When I log in with valid credentials
    And I click the button "Join" that is under the div with class name "Test_World_1"
    Then I should see the exact phrase "World Name: Test World 1"
    And I press the button "Gamble"
    Then I should see the exact phrase "Blackjack"
    And I press the button "Play"
    And I do not have a blackjack and the dealer does
    Then I should see the exact phrase "Dealer Blackjack! Dealer Wins!"

  @javascript
  Scenario: Both the dealer and I get a blackjack and it's a push
    When I log in with valid credentials
    And I click the button "Join" that is under the div with class name "Test_World_1"
    Then I should see the exact phrase "World Name: Test World 1"
    And I press the button "Gamble"
    Then I should see the exact phrase "Blackjack"
    And I press the button "Play"
    And I have a blackjack and the dealer does
    Then I should see the exact phrase "Push! Both Player and Dealer have Blackjack!"

  @javascript
  Scenario: I have a higher hand and I win
    When I log in with valid credentials
    And I click the button "Join" that is under the div with class name "Test_World_1"
    Then I should see the exact phrase "World Name: Test World 1"
    And I press the button "Gamble"
    Then I should see the exact phrase "Blackjack"
    And I press the button "Play"
    And I have a higher hand than the dealer
    And I press the button "Stand"
    Then I should see the exact phrase "Player Wins!"

  @javascript
  Scenario: The dealer has a higher hand and I lose
    When I log in with valid credentials
    And I click the button "Join" that is under the div with class name "Test_World_1"
    Then I should see the exact phrase "World Name: Test World 1"
    And I press the button "Gamble"
    Then I should see the exact phrase "Blackjack"
    And I press the button "Play"
    And I have a lower hand than the dealer
    And I press the button "Stand"
    Then I should see the exact phrase "Dealer Wins!"

  @javascript
  Scenario: The dealer and I have an equal hand and its push
    When I log in with valid credentials
    And I click the button "Join" that is under the div with class name "Test_World_1"
    Then I should see the exact phrase "World Name: Test World 1"
    And I press the button "Gamble"
    Then I should see the exact phrase "Blackjack"
    And I press the button "Play"
    And I have an equal hand to the dealer
    And I press the button "Stand"
    Then I should see the exact phrase "Push!"

  @javascript
  Scenario: I bust and I lose
    When I log in with valid credentials
    And I click the button "Join" that is under the div with class name "Test_World_1"
    Then I should see the exact phrase "World Name: Test World 1"
    And I press the button "Gamble"
    Then I should see the exact phrase "Blackjack"
    And I press the button "Play"
    And I hit and bust
    Then I should see the exact phrase "Player Bust! Dealer Wins!"

  @javascript
  Scenario: The dealer busts and I win
    When I log in with valid credentials
    And I click the button "Join" that is under the div with class name "Test_World_1"
    Then I should see the exact phrase "World Name: Test World 1"
    And I press the button "Gamble"
    Then I should see the exact phrase "Blackjack"
    And I press the button "Play"
    And I stand and the dealer busts
    Then I should see the exact phrase "Dealer Bust! Player Wins!"