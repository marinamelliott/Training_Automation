Feature: Verify the understanding of each step definition in Page Steps

  Scenario: The application navigates to/remains on the Product Registration page
    Given the application navigates to the Product Registration page
    And the application remains on the Home page
    And the application navigates to the Huntington page

  Scenario: The user clicks the <page_element>
    Given the user clicks the sign up button

  Scenario: Take a screenshot
    Given take a screenshot

  Scenario: A new browser window opens
    Given a new browser window opens

  Scenario: The user confirms/cancels on the alert box
    Given the user confirms on the alert box
    And the user cancels on the alert box

