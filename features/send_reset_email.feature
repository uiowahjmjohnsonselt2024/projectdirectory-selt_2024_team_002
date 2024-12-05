Feature: Send myself a reset password email
  As a User
  So that I can reset my password

  Scenario: Send reset password email with valid email
    Given I am on the Forgot Password page
    And I fill in "Enter your email:" with "admin@admin.com"
    And I press the button "Send Password Reset Email"
    Then I should see a string that starts with "Password reset email sent"

  Scenario: Send reset password email with invalid email
    Given I am on the Forgot Password page
    And I fill in "Enter your email:" with "wrong@wrong.com"
    And I press the button "Send Password Reset Email"
    Then I should see a string that starts with "User not found from the given email"