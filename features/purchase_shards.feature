Feature: Purchase shards with any currency
  As a user
  So that I can spend them in game

  Background:
    Given I log in with valid credentials
    Given I am on the purchase shards page

  Scenario: Purchase shards with USD
    When I fill in "Enter the amount of shards:" with 75 and currency "USD"
    Then I should see the content of "Price per shard" be "0.75" and "Total amount" be "56.25"
    And I submit the Proceed to Checkout form for shards
    And I fill in "Card Number:" with "378282246310005"
    And I fill in "Expiration Date (MMYY):" with "1220"
    And I fill in "CVV:" with "123"
    And I fill in "Billing Address:" with "1234 Test Address"
    And I press the button "Pay"
    Then I should have the correct amount of shards
