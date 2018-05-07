Feature: Scenarios for Example 1

  Scenario: Validate example1 testing website
    Given the user navigates to the example1 testing website
    When the user clicks AB Testing
    Then the application navigates to the AB Testing page

  Scenario: Validate example1 testing website
    Given the user navigates to the example1 testing website
    When the user clicks Broken Images
    Then the application navigates to the Broken Images page

  Scenario: Validate example1 testing website
    Given the user navigates to the example1 testing website
    When the user clicks Challenging DOM
    Then the application navigates to the Challenging DOM page

  Scenario: Validate example1 testing website
    Given the user navigates to the example1 testing website
    When the user clicks Checkboxes
    Then the application navigates to the Checkboxes page

  Scenario: Validate example1 testing website
    Given the user navigates to the example1 testing website
    When the user clicks Context Menu
    Then the application navigates to the Context Menu page

  Scenario: Validate example1 testing website
    Given the user navigates to the example1 testing website
    When the user clicks Disappearing Elements
    Then the application navigates to the Disappearing Elements page

  Scenario: Validate example1 testing website
    Given the user navigates to the example1 testing website
    When the user clicks Drag and Drop
    Then the application navigates to the Drag and Drop page

  Scenario: Validate example1 testing website
    Given the user navigates to the example1 testing website
    When the user clicks Dropdown
    Then the application navigates to the Dropdown page

  Scenario: Validate example1 testing website
    Given the user navigates to the example1 testing website
    When the user clicks Dynamic Content
    Then the application navigates to the Dynamic Content page

  Scenario Outline: Navigation
    When the user clicks <link>
    Then the application navigates to the <page_name> page
  Examples:
    | link                  | page_name             |
    | AB Testing            | AB Testing            |
    | Broken Images         | Broken Images         |
    | Challenging DOM       | Challenging DOM       |
    | Checkboxes            | Checkboxes            |
    | Context Menu          | Context Menu          |
    | Disappearing Elements | Disappearing Elements |
    | Drag and Drop         | Drag and Drop         |
    | Dropdown              | Dropdown              |
    | Dynamic Content       | Dynamic Content       |


