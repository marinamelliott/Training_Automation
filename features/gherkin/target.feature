Feature: Training Examples

  @TC-12345 @target @regression
  Scenario: Potential customer can search for a coffee maker
    Given the user navigates to the Target website
    And the user fills in "coffee maker" for search field
    And the user clicks the go button
    And the application navigates to the target search coffee maker page
    And the user views the page again
    And the user clicks the keurig elite button

  @TC-12345 @target @regression
  Scenario: Potential customer can navigate to the womens clothing page
    Given the user navigates to the Target website
    And the user navigates to the womens clothing page by the categories list
    And the application navigates to the target womens clothing page
    And the user views the page again

  @TC-12345 @target @regression
  Scenario: Potential customer can navigate to the swimsuit page
    Given the user navigates to the Target website
    And the user clicks the categories link
    And the user clicks the clothing button
    And the user clicks the womens clothing buttom
    And the user clicks the all womens clothing button
    And the application navigates to the target womens clothing page
    And the user views the page again
    And the user clicks the bikini show button

  @TC-12345 @target @regression
  Scenario: Potential customer can navigate to the juniors clothing page
    Given the user navigates to the Target website
    And the user clicks the categories link
    And the user clicks the clothing button
    And the user clicks the womens clothing buttom
    And the user clicks the all womens clothing button
    And the application navigates to the target womens clothing page
    And the user views the page again
    And the user clicks the juniors clothing button

  @TC-12345 @target @regression
  Scenario: Potential customer can navigate to the juniors clothing page
    Given the user navigates to the Target website
    And the user clicks the my account button
    And the user clicks the create account button
    When the application navigates to the target create account page
    And the user fills the target create account page