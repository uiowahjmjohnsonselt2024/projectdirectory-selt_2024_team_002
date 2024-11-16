Feature: Allow Application user to add a new world

Scenario:  Add a new world (Declarative)
  When I am on the Creation World page
  And I enter the fields with world name "Test Cucumber", world code "11111", public is "true", and max player to be "10"
  And I submit the "CREATE" form
  Then I should see a world list entry in the "public" tab with world name "Test Cucumber" and world code "11111"

