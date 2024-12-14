Feature: Use my inventory
  As a user
  So I can see and use my items in a world

  @javascript
  Scenario: See item after buying in shop
    When I log in with valid credentials
    Then I should be redirected to "/worlds"
    And I click the button "Join" that is under the div with class name "Test_World_1"
    Then I should see the exact phrase "World Name: Test World 1"
    And I press the button "Replenish"
    Then I should see a string that starts with "Shop"
    When I fill in "Enter the amount of shards:" with 75 and currency "USD"
    Then I should see the content of "Price per shard" be "0.75" and "Total amount" be "56.25"
    And I submit the Proceed to Checkout form for shards
    And I fill in "Card Number:" with "378282246310005"
    And I fill in "Expiration Date (MMYY):" with "1220"
    And I fill in "CVV:" with "123"
    And I fill in "Billing Address:" with "1234 Test Address"
    And I press the button "Pay"
    And I press the button "<"
    Then I should see the exact phrase "World Name: Test World 1"
    And I press the button "Shop"
    Then I should see a string that starts with "Shop"
    And I press the button "+" on index "0" to increase or decrease amount
    And I press the button "Buy"
    And I press the button "Inventory"
    Then I should see a string that starts with "Inventory"
    Then I should see a string that starts with "XP Boost"

  @javascript
  Scenario: See no items in inventory
    When I log in with valid credentials
    Then I should be redirected to "/worlds"
    And I click the button "Join" that is under the div with class name "Test_World_1"
    Then I should see the exact phrase "World Name: Test World 1"
    And I press the button "Inventory"
    Then I should see a string that starts with "No items in inventory"

  @javascript
  Scenario: Use an XP Boost item
    When I log in with valid credentials
    Then I should be redirected to "/worlds"
    And I click the button "Join" that is under the div with class name "Test_World_1"
    Then I should see the exact phrase "World Name: Test World 1"
    And I press the button "Replenish"
    Then I should see a string that starts with "Shop"
    When I fill in "Enter the amount of shards:" with 75 and currency "USD"
    Then I should see the content of "Price per shard" be "0.75" and "Total amount" be "56.25"
    And I submit the Proceed to Checkout form for shards
    And I fill in "Card Number:" with "378282246310005"
    And I fill in "Expiration Date (MMYY):" with "1220"
    And I fill in "CVV:" with "123"
    And I fill in "Billing Address:" with "1234 Test Address"
    And I press the button "Pay"
    And I press the button "<"
    Then I should see the exact phrase "World Name: Test World 1"
    And I press the button "Shop"
    Then I should see a string that starts with "Shop"
    And I press the button "+" on index "0" to increase or decrease amount
    And I press the button "Buy"
    And I wait for 2 seconds
    And I press the button "Inventory"
    Then I should see a string that starts with "Inventory"
    Then I should see a string that starts with "XP Boost"
    And I press the button "Use"
    Then I should see a string that starts with "XP Boost was used!"

  @javascript
  Scenario: Use a Speed Potion item
    When I log in with valid credentials
    Then I should be redirected to "/worlds"
    And I click the button "Join" that is under the div with class name "Test_World_1"
    Then I should see the exact phrase "World Name: Test World 1"
    And I press the button "Replenish"
    Then I should see a string that starts with "Shop"
    When I fill in "Enter the amount of shards:" with 75 and currency "USD"
    Then I should see the content of "Price per shard" be "0.75" and "Total amount" be "56.25"
    And I submit the Proceed to Checkout form for shards
    And I fill in "Card Number:" with "378282246310005"
    And I fill in "Expiration Date (MMYY):" with "1220"
    And I fill in "CVV:" with "123"
    And I fill in "Billing Address:" with "1234 Test Address"
    And I press the button "Pay"
    And I press the button "<"
    Then I should see the exact phrase "World Name: Test World 1"
    And I press the button "Shop"
    Then I should see a string that starts with "Shop"
    And I press the button "+" on index "1" to increase or decrease amount
    And I press the button "Buy"
    And I wait for 2 seconds
    And I press the button "Inventory"
    Then I should see a string that starts with "Inventory"
    Then I should see a string that starts with "Speed Potion"
    And I press the button "Use"
    Then I should see a string that starts with "Speed Potion was used!"
    And I press the button "Inventory"
    And I wait for 5 seconds
    Then I should not see the exact phrase "Speed Potion"

  @javascript
  Scenario: Use a 4 Leaf Clover item
    When I log in with valid credentials
    Then I should be redirected to "/worlds"
    And I click the button "Join" that is under the div with class name "Test_World_1"
    Then I should see the exact phrase "World Name: Test World 1"
    And I press the button "Replenish"
    Then I should see a string that starts with "Shop"
    When I fill in "Enter the amount of shards:" with 75 and currency "USD"
    Then I should see the content of "Price per shard" be "0.75" and "Total amount" be "56.25"
    And I submit the Proceed to Checkout form for shards
    And I fill in "Card Number:" with "378282246310005"
    And I fill in "Expiration Date (MMYY):" with "1220"
    And I fill in "CVV:" with "123"
    And I fill in "Billing Address:" with "1234 Test Address"
    And I press the button "Pay"
    And I press the button "<"
    Then I should see the exact phrase "World Name: Test World 1"
    And I press the button "Shop"
    Then I should see a string that starts with "Shop"
    And I press the button "+" on index "2" to increase or decrease amount
    And I press the button "Buy"
    And I wait for 2 seconds
    And I press the button "Inventory"
    Then I should see a string that starts with "Inventory"
    Then I should see a string that starts with "4 Leaf Clover"
    And I press the button "Use"
    Then I should see a string that starts with "4 Leaf Clover was used!"

