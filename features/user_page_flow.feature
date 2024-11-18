Feature: Allow Application user to view the friend list
  As a user
  So that I can navigate between create account and login

Scenario: Go to create accout from login
  When I am on the Login page
  And I press the link "Sign Up"
  Then I should be redirected to "/users/new"

Scenario: Go to login from create account
  When I am on the Create Account page
  And I press the link "Log In"
  Then I should be redirected to "/users/login"