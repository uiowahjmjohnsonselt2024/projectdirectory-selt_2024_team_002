Feature: Purchase shards with any currency
  As a user
  So that I can spend them in game

  # US Dollar
  Scenario: Purchase shards with USD
    When I purchase shards with 10 USD
    And I press the button "Proceed to Checkout"
    And I fill in "Card Number" with "1234567890123456"
    And I fill in "Expiration Date" with "12/20"
    And I fill in "CVV" with "123"
    And I press the button "Purchase"
    Then I should have 100 shards

  # Canadian Dollar
  Scenario: Purchase shards with CAD
    When I purchase shards with 10 CAD
    And I press the button "Proceed to Checkout"
    And I fill in "Card Number" with "1234567890123456"
    And I fill in "Expiration Date" with "12/20"
    And I fill in "CVV" with "123"
    And I press the button "Purchase"
    Then I should have X shards

  # British Pound
  Scenario: Purchase shards with GBP
    When I purchase shards with 10 GBP
    And I press the button "Proceed to Checkout"
    And I fill in "Card Number" with "1234567890123456"
    And I fill in "Expiration Date" with "12/20"
    And I fill in "CVV" with "123"
    And I press the button "Purchase"
    Then I should have X shards

  # Euro
  Scenario: Purchase shards with EUR
    When I purchase shards with 10 EUR
    And I press the button "Proceed to Checkout"
    And I fill in "Card Number" with "1234567890123456"
    And I fill in "Expiration Date" with "12/20"
    And I fill in "CVV" with "123"
    And I press the button "Purchase"
    Then I should have X shards

  # Japanese Yen
  Scenario: Purchase shards with JPY
    When I purchase shards with 10 JPY
    And I press the button "Proceed to Checkout"
    And I fill in "Card Number" with "1234567890123456"
    And I fill in "Expiration Date" with "12/20"
    And I fill in "CVV" with "123"
    And I press the button "Purchase"
    Then I should have X shards