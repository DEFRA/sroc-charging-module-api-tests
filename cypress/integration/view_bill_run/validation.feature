Feature: View Bill Run Validation

  Background: Authenticate
    Given I am the "system" user

  Scenario: Making a view bill run request with an unknown Bill run ID
    When I request a valid new sroc bill run
     And I add a successful sroc standard transaction for customer CM00000001
     And I request to generate the bill run
    Then I request to view the bill run with an unknown bill run id I am told that bill run id is unknown

  Scenario: Generating a bill run request with an unknown Bill Run ID
    When I request a valid new sroc bill run
     And I add a successful sroc standard transaction for customer CM00000001
    Then I request to generate the bill run with an unknown bill run id I am told that bill run id is unknown

  Scenario: Generating a bill run without transactions
    When I request a valid new sroc bill run
     And I request to generate the bill run I am told that Bill run cannot be generated without any transactions