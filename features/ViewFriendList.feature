Feature: Allow Application user to view the friend list

Scenario:  View a Friend list
  When I am on the World Homepage
  And I click on the "Friends" tab
  Then I should see either the text "Sorry, you currently have no friend" or a list entry with "UID" and "Name"