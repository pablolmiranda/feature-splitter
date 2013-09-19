Feature: Y! Mail ViewMastr App
    In order see all my attachments  As a Y! Mail user
    I want an App to interact with my attachments

Background:
    Given I am logged in MintyFresh with: User1
    And I make sure the Applications list is expanded
    And I wait for 3 seconds

@smoke
Scenario: Clicking email subject in Attachments should open email in new tab
    And I click on "Attachments" from Applications View
    And I click on the email subject: "bunch of attachments" (Attachments)
    Then I should see a new tab labeled either as "bunch of attachments" or "Message"