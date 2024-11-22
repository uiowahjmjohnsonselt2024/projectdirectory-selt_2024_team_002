Feature: Allow Application user to view the friend list
  As a user
  So that I can see my in game friends

Scenario:  View a Friend list
  When I log in with valid credentials
  And I click on the "Friends" tab
  Then I should see either the text "Sorry, you currently have no friend" or a list entry with "UID" and "Name"