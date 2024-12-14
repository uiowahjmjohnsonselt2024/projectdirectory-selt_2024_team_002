Feature: Reset my password when I've forgotten it
  As a User
  So that I can access my account

  Scenario: Reset password with valid password and login
    When I am on the Reset Password page with correct credentials
    And I fill in "New Password:" with "AdminsAreTheBest100$"
    And I fill in "Confirm New Password:" with "AdminsAreTheBest100$"
    And I press the button "Reset Password"
    Then I should see a string that starts with "Password reset successful"
    And I fill in "Username:" with "admin"
    And I fill in "Password:" with "AdminsAreTheBest100$"
    And I press the button "Log In"
    Then I should be redirected to "/worlds"

#  Scenario: Reset password with invalid password
#    When I am on the Reset Password page with correct credentials
#    And I fill in "New Password:" with "1234"
#    And I fill in "Confirm New Password:" with "1234"
#    And I press the button "Reset Password"
#    And I wait for 2 seconds
#    Then I should see a string that starts with "Password"

  Scenario: Reset password with non-matching password
    When I am on the Reset Password page with correct credentials
    And I fill in "New Password:" with "AdminsAreTheBest1$"
    And I fill in "Confirm New Password:" with "AdminsAreTheWorst1$"
    And I press the button "Reset Password"
    Then I should see a string that starts with "Password confirmation must match"