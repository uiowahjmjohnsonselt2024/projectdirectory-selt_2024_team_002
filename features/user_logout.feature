Feature: Allow Application user to add a new world
  As a user
  so that I can log out of my account

Scenario: Add a new world (Declarative)
  When I log in with valid credentials
  When I am on the world index page
  And I press the button "Log Out"
  Then I should be redirected to "/users/login"
  # user has no valid session, so world index should bounce to login
  And I am on the world index page 
  Then I should be redirected to "/users/login"
