Feature: Bill runs

  Background: Authenticate
    Given I am the "system" user
    When I request a valid new presroc bill run

  Scenario: Creating a new bill run
    Then the bill run ID and number are returned

  Scenario: Viewing a bill run
    Then details of the bill run are returned

  Scenario: Generating a bill run
    And I add 10 standard transactions to it
    And I request to generate the bill run
    Then bill run status is updated to "generated"

  Scenario: Approving a bill run
    And I add 5 standard transactions to it
    And I request to generate the bill run
    And bill run status is updated to "generated"
    And I request to approve the bill run
    Then bill run status is updated to "approved"

  Scenario: Sending a bill run
    And I add 5 standard transactions to it
    And I request to generate the bill run
    And bill run status is updated to "generated"
    And I request to approve the bill run
    And bill run status is updated to "approved"
    And I request to send the bill run
    Then bill run status is updated to "billed"

  Scenario: Deleting a bill run
    And I add 5 standard transactions to it
    And I request to generate the bill run
    And bill run status is updated to "generated"
    And I request to delete the bill run
    Then bill run is not found
