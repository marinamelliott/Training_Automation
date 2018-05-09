Feature: Training Examples

  @TC-12345 @jj @regression @run
  Scenario: Customer can make a customized order
    Given the user navigates to the JJ website
    And the user fills the jimmy johns page with Kforce
    And the user clicks the delivery button
    And the application navigates to the verify address page
    And the user clicks the verify address button
    And the application navigates to the order menu page
    When the user clicks the classics button
    And the user clicks the turkey tom button
    And the application navigates to the customize order page
    And the user fills the customize order page with Marina
    And the user clicks the add to order button
    Then the user views the page
    And the application navigates to the review order page

  @TC-12345 @jj @regression @off_hours
  Scenario: Verify store closed pop-up - off hours
    Given the user navigates to the JJ website
    And the user fills in "400 Metro Place N" for street address
    And the user clicks the delivery button
    And the application navigates to the verify address page
    And the user clicks the verify address button
    And the application navigates to the order menu page
    And the text for store closed is displayed in the store closed pop up
    And the user views the page again

  @TC-12345 @jj @regression
  Scenario: Customize order page - verify drink options
    Given the user navigates to the JJ website
    And the user fills the jimmy johns page with Kforce
    And the user clicks the delivery button
    And the application navigates to the verify address page
    And the user clicks the verify address button
    And the application navigates to the order menu page
    And the user clicks the classics button
    And the user clicks the turkey tom button
    And the application navigates to the customize order page
    And the select list values for add chips list are correct

  @TC-12345 @jj @regression
  Scenario: Customize order page - verify default selections
    Given the user navigates to the JJ website
    And the user fills the jimmy johns page with Kforce
    And the user clicks the delivery button
    And the application navigates to the verify address page
    And the user clicks the verify address button
    And the application navigates to the order menu page
    And the user clicks the classics button
    And the user clicks the turkey tom button
    And the application navigates to the customize order page
    And the field values are correct for defaults

  @TC-12345 @jj @regression
  Scenario: Customer can order a sandwich using dropdown lists
    Given the user navigates to the JJ website
    And the user fills the jimmy johns page with Kforce
    And the user clicks the delivery button
    And the application navigates to the verify address page
    And the user clicks the verify address button
    And the application navigates to the order menu page
    And the user clicks the clasics button
    And the user clicks the turkey tom button
    And the application navigates to the customize order page
    And the user fills in "Marina" for order name
    And the user selects the 2nd option from the select bread list
    And the user selects the 5th option from the add drink list 
    And the user selects the 2nd option from the add chips list
    And the user selects the 2nd option from the add cookie list 
    And the user selects the 3rd option from the add pickle list
    And the user clicks the add to order button
    And the user views the page
    And the application navigates to the review order page
    And the user views the page again

  @TC-12345 @jj @regression
  Scenario: Customer can navigate to customize order page using tab and enter
    Given the user navigates to the JJ website
    And the user fills the jimmy johns page with Kforce
    And the user presses the tab keyboard key
    And the user presses the enter keyboard key
    And the user views the page

  @TC-12345 @jj @regression
  Scenario: Customer can make a customized order
    Given the user navigates to the JJ website
    And the user fills the jimmy johns page with Kforce
    And the user clicks the delivery button
    And the application navigates to the verify address page
    And the user clicks the verify address button
    And the application navigates to the order menu page
    And the user clicks the classics button
    And the user clicks the turkey tom button
    And the application navigates to the customize order page
    And the user fills the customize order page with Marina
    And take a screenshot