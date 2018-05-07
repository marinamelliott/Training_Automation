Feature: Verify the understanding of each step definition in Validation Steps

  Scenario: The <page_element> value defaults to/is/is not <some_value>
    Given the username value defaults to blank
    And the email value is test@mail.com
    And the email value is not blank

  Scenario: The field values are correct for <data_key>
    Given the field values are correct for default product registration
    Given the field values are correct for default second page

  Scenario: The <parent_radio> radio group has a/has no selection
    Given the tool type radio group has a selection
    And the tool type radio group has no selection

  Scenario: The <checkbox_name> checkbox is checked/unchecked/enabled/disabled
    Given the yes I agree checkbox is checked
    And the yes I agree checkbox is unchecked
    And the yes I agree checkbox is enabled
    And the yes I agree checkbox is disabled

  Scenario: The page displays/does not display the <page_element> field|dialog|element|section|checkbox
    Given the page displays the first name field
    And the page displays the first name dialog
    And the page displays the first name element
    And the page displays the first name section
    And the page displays the first name checkbox
    And the page does not display the first name field
    And the page does not display the first name dialog
    And the page does not display the first name element
    And the page does not display the first name section
    And the page does not display the first name checkbox

  Scenario: The select list/radio group values for <page_element_name> are correct
    Given the select list values for country are correct
    And the radio group values for tool type are correct
    And the select list values for drop down are correct

  Scenario: The page displays/does not display the following elements/fields: - as enabled/disabled:
    Given the page displays the following elements:
      | list of elements |
    Given the page displays the following fields:
      | list of fields |
    Given the page does not display the following elements:
      | list of elements |
    Given the page displays the following elements as enabled:
      | list of elements |
    Given the page displays the following elements as disabled:
      | list of elements |

  Scenario: The error message/warning message/success message/text for <data_key> is displayed - in/as the <page_element>
    Given the error message for invalid email is displayed
    Given the error message for invalid email is displayed as the email label
    Given the warning message for invalid email is displayed
    Given the success message for congratulations is displayed
    Given the text for skill level is displayed in the project of the month details

  Scenario: The title/url of the browser window is/contains <some_string>
    Given the title of the browser window is Ideas + Inspiration
    And the url of the browser window contains ideas-and-inspiration

  Scenario: The <page_element_name> button/drop down/text field is disabled/enabled
    Given the submit button is disabled
    Given the submit button is enabled
    Given the first name text field is enabled

  Scenario: An alert box opens with the text for <data_key>
    Given an alert box opens with the text for please confirm

