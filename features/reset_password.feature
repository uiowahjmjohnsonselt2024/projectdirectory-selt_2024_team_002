Feature: Reset my password when I've forgotten it
  As a User
  So that I can access my account

  Scenario: Reset password with valid email/password and login
    When I am on the Reset Password page
    And I fill in "Email:" with "admin@admin.com"
    And I fill in "New Password:" with "AdminsAreTheBest100$"
    And I fill in "Confirm New Password:" with "AdminsAreTheBest100$"
    And I press the button "Reset Password"
    Then I should see a string that starts with "Password reset successful"
    And I fill in "Username:" with "admin"
    And I fill in "Password:" with "AdminsAreTheBest100$"
    And I press the button "Log In"
    Then I should be redirected to "/worlds"

    Scenario: Reset password with invalid email
    When I am on the Reset Password page
    And I fill in "Email:" with "none@none.com"
    And I fill in "New Password:" with "AdminsAreTheBest1$"
    And I fill in "Confirm New Password:" with "AdminsAreTheBest1$"
    And I press the button "Reset Password"
    Then I should see a string that starts with "Email is not associated with an existing user"

    Scenario: Reset password with invalid password
    When I am on the Reset Password page
    And I fill in "Email:" with "admin@admin.com"
    And I fill in "New Password:" with "1234"
    And I fill in "Confirm New Password:" with "1234"
    And I press the button "Reset Password"
    Then I should see a string that starts with "Password must"

    Scenario: Reset password with non-matching password
    When I am on the Reset Password page
    And I fill in "Email:" with "admin@admin.com"
    And I fill in "New Password:" with "AdminsAreTheBest1$"
    And I fill in "Confirm New Password:" with "AdminsAreTheWorst1$"
    And I press the button "Reset Password"
    Then I should see a string that starts with "Password confirmation must match"