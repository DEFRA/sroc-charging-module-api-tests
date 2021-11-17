Feature: Calculate Charge Validation

  Background: Authenticate
    Given I am the "system" user

  Scenario Outline: Ruleset must be a known value
    When the ruleset is set to <ruleset>
    Then I get a <status> response

    Examples:
      | ruleset | status |
      | sroc    | 200    |
      | presroc | 200    |
      | cors    | 422    |
