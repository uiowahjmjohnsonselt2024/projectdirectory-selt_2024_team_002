Feature: Create account with user information
  As a user
  so I have an account to access the game

Scenario: Create account with non-unique display name
  When I am on the Create Account page
  And I fill in "Email:" with "test@test.com"
  And I fill in "Display Name:" with "admin"
  And I fill in "Password:" with "FFFFaaasf@@#11"
  And I fill in "Confirm Password:" with "FFFFaaasf@@#11"
  And I press the button "Sign Up"
  Then I should see the exact phrase "Display name admin is taken"

Scenario: Create account with non matching password
  When I am on the Create Account page
  And I fill in "Email:" with "test@test.com"
  And I fill in "Display Name:" with "admin"
  And I fill in "Password:" with "FFFFaaasf@@#11"
  And I fill in "Confirm Password:" with "ffffffff"
  And I press the button "Sign Up"
  Then I should see the exact phrase "Password confirmation must match"
  
Scenario: Create account with weak password
  When I am on the Create Account page
  And I fill in "Email:" with "test@test.com"
  And I fill in "Display Name:" with "SKT T1 Faker"
  And I fill in "Password:" with "aaaaaaaaaaaaa"
  And I fill in "Confirm Password:" with "aaaaaaaaaaaaa"
  And I press the button "Sign Up"
  Then I should see a string that starts with "Password must include"

Scenario: Create account with invalid Email
  When I am on the Create Account page
  And I fill in "Email:" with "bad email"
  And I fill in "Display Name:" with "SKT T1 Faker"
  And I fill in "Password:" with "FFFFaaasf@@#11"
  And I fill in "Confirm Password:" with "FFFFaaasf@@#11"
  And I press the button "Sign Up"
  Then I should see the exact phrase "Email is invalid"

Scenario: Create account with correct details and log in with that accout
  When I am on the Create Account page
  And I fill in "Email:" with "aguo2@uiowa.edu"
  And I fill in "Display Name:" with "SKT T1 Faker"
  And I fill in "Password:" with "FFFFaaasf@@#11"
  And I fill in "Confirm Password:" with "FFFFaaasf@@#11"
  And I press the button "Sign Up"
  Then I should be redirected to "/users/login"
  Then I should see the exact phrase "Account created successfully"
  And I fill in "Username:" with "SKT T1 Faker"
  And I fill in "Password:" with "FFFFaaasf@@#11"
  And I press the button "Log In"
  Then I should be redirected to "/worlds"