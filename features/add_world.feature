Feature: Allow Application user to add a new world
  As a user
  so that I can create a new world

Scenario: Add a new world (Declarative)
  When I log in with valid credentials
  When I am on the Creation World page
  And I enter the fields with world name "Test Cucumber", world code "11111", public is "true", and max player to be "10"
  And I submit the "Create" form
  Then I should see a world list entry in the "public" tab with world name "Test Cucumber" and world code "11111"

Scenario: Can't go to worlds page without login
  When I am on the Creation World page
  Then I should be redirected to "/users/login"