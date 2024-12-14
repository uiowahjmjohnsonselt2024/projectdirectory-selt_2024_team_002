Feature: Allow Application user to view the friend list
  As a user
  So that I can see my in game friends

@javascript
Scenario:  View the Friend list with no friends.
  When I log in with valid credentials
  And I click on the "Friends" tab
  Then I should see the exact phrase "Sorry, you currently have no friends. Add some below!"

@javascript
Scenario:  View the Friend list after adding a friend.
  When I am on the Create Account page
  And I create a user with email: "aguo2@uiowa.edu", username: "bob", password: "FFFFaaasf@@#11"
  And I fill in "Username:" with "bob"
  And I fill in "Password:" with "FFFFaaasf@@#11"
  And I press the button "Log In"
  And I click on the "Friends" tab
  And I press the button "Add Friend"
  And I fill in the input input box with id "friend_name" with the text "admin"
  And I press the button "Submit"
  And I press the button "Logout"
  And I am on the home page
  And I fill in "Username:" with "admin"
  And I fill in "Password:" with "AdminsAreTheBest1$"
  And I press the button "Log In"
  And I click on the "Friend Requests" tab
  Then I should see the exact phrase "bob"
  And I press the button "Approve"
  And I am on the home page
  And I click on the "Friends" tab
  And I wait for 2 seconds
  Then I should see the exact phrase "bob"
  
