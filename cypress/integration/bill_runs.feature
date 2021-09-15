Feature: Bill runs

  Background: Authenticate
    Given I am the 'system' user

  @ignore
  Scenario: Creating a new bill run
    When I request a new bill run
    Then the bill run ID and number are returned

  @ignore
  Scenario: Viewing a bill run
    When I request to view a bill run
    Then details of the bill run are returned

  Scenario: Generating a bill run
    When I request a new bill run
    And I add 10 standard transactions to it
    And I request to generate the bill run
    Then bill run status is updated to 'generated'
