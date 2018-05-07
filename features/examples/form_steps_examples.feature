Feature: Verify the understanding of each step definition in Form Steps

  Scenario: The user checks/unchecks <checkbox_name>
    Given the user checks yes I agree
    And the user checks yes I agree, subscribe email

  Scenario: The user selects/fills in "<some_value>" for <page_element>
    Given the user fills in "Tools" for site search
    And the user selects "United States" for country list

  Scenario: The user fills/modifies the <page_name> page with <data_key>
    Given the user fills the Home page with test credentials
    And the user modifies the Product Registration page with valid model number

  Scenario: The user views the page
    Given the user views the page
    And the user views the page again

  Scenario: The user selects the 1st/2nd/3rd/4th <radio_button_name> radio button
    Given the user selects the 2nd marital status radio button

  Scenario: The user selects the 1st/2nd/3rd/4th option from the <select_list_name>
    Given the user selects the 2nd option from the dropdown

  Scenario: The user presses the <any_key> keyboard key
    Given the user presses the enter keyboard key
    And the user presses the tab keyboard key

