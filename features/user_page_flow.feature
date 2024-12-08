Feature: Allow Application user to view the friend list
  As a user
  So that I can navigate between create account and login

Scenario: Go to create account from login
  When I am on the Login page
  And I press the link "Sign up"
  Then I should see a string that starts with "Sign Up"

Scenario: Go to forgot password page
  When I am on the Login page
  And I press the link "Forgot Password"
  Then I should see a string that starts with "Reset Password"