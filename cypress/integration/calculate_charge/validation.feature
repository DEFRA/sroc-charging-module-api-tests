Feature: Calculate Charge Validation

  Background: Authenticate
    Given I am the "system" user

  Scenario: Ruleset must be a known value (datatable)
    When I use the following ruleset values I get the expected response
      | sroc    | 200 |
      | presroc | 200 |
      | cors    | 422 |
