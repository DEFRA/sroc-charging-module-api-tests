Feature: Bill runs

  Background: Authenticate
    Given I am the 'system' user

  Scenario: Creating a new bill run
    When I request a new bill run
    Then the bill run ID and number are returned

  Scenario: Viewing a bill run
    When I request to view a bill run
    Then details of the bill run are returned

  Scenario: Generating a bill run
    When I request to generate a bill run
    Then bill run status is updated to 'generated'
