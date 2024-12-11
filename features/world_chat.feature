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