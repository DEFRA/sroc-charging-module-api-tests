Feature: Status

  Scenario: GET status
  Given I request the /status endpoint
  Then the status response is as expected
