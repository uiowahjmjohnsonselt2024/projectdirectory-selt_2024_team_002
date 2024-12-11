Feature: chatting in the world
  As a user
  So I can chat with other player

@javascript
Scenario: chatting
  When I log in with valid credentials
  And I click the button "Join" that is under the div with class name "Test_World_1"
  Then I should see the exact phrase "World Name: Test World 1"
  And I press the button "Chat"
  Then I should see a string that starts with "World Chat"
  And I fill in "chat_text_area" with "This is a test chat"
  And I press the button "Send Chat"
  Then I should see a string that starts with "This is a test chat"

@javascript
Scenario: chatting from the other user
  When I log in with valid credentials
  And I click the button "Join" that is under the div with class name "Test_World_1"
  Then I should see the exact phrase "World Name: Test World 1"
  And I press the button "Chat"
  Then I should see a string that starts with "World Chat"
  And I fill in "chat_text_area" with "This is a test chat"
  And I press the button "Send Chat"
  Then I should see a string that starts with "This is a test chat"
  And I click the link by ID "#close_chat_link"
  And I press the button "Back to Worlds"
  And I press the button "Logout"
  Then I should be redirected to "/users/login"
  When I am on the Create Account page
  And I create a user with email: "aguo2@uiowa.edu", username: "SKT T1 Faker", password: "FFFFaaasf@@#11"
  And I fill in "Username:" with "SKT T1 Faker"
  And I fill in "Password:" with "FFFFaaasf@@#11"
  And I press the button "Log In"
  Then I should be redirected to "/worlds"
  And I click the button "Join" that is under the div with class name "Test_World_1"
  Then I should see the exact phrase "World Name: Test World"
  And I press the button "Chat"
  Then I should see a string that starts with "World Chat"
  Then I should see a string that starts with "This is a test chat"