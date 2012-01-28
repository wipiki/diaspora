#@javascript
Feature: Not safe for work

Scenario: Setting not safe for work
  Given a user named "pr0n king" with email "tommy@pr0n.xxx"
  And I sign in as "tommy@pr0n.xxx"
  When I go to the edit profile page
  And I should see the "you are safe for work" message
  And I mark myself as not safe for work
  And I submit the form
  Then I should be on the edit profile page
  And I should see the "you are nsfw" message
