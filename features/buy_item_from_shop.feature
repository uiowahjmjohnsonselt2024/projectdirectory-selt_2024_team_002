Feature: buy items from shop
  As a user
  So I can buy items from shop in world

@javascript
Scenario: buy item from shop enough credit
  When I am on the Create Account page
  And I create a user with email: "aguo2@uiowa.edu", username: "SKT T1 Faker", password: "FFFFaaasf@@#11"
  And I fill in "Username:" with "SKT T1 Faker"
  And I fill in "Password:" with "FFFFaaasf@@#11"
  And I press the button "Log In"
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
  Then I should see a string that starts with "Cell Shop"
  And I press the button "+" to increase or decrease amount
  And I press the button "Buy"
  Then I should see my shard decrease from "75" shards

Scenario: buy item from shop not enough credit
  When I am on the Create Account page
  And I create a user with email: "aguo2@uiowa.edu", username: "SKT T1 Faker", password: "FFFFaaasf@@#11"
  And I fill in "Username:" with "SKT T1 Faker"
  And I fill in "Password:" with "FFFFaaasf@@#11"
  And I press the button "Log In"
  Then I should be redirected to "/worlds"
  And I click the button "Join" that is under the div with class name "Test_World_1"
  Then I should see the exact phrase "World Name: Test World 1"
  And I press the button "Shop"
  Then I should see a string that starts with "Cell Shop"
  And I press the button "+" to increase or decrease amount
  And I press the button "Buy"
  Then I should see a string that starts with "No sufficient shard to purchase"
