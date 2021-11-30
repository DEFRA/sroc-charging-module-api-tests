Feature: Create Transaction General

  Background: Authenticate
    Given I am the "system" user

  Scenario: Making a valid request (SROC)
    When I request a valid new sroc bill run
     And I add a standard sroc transaction to it
    Then I get a successful response

  Scenario: Making an invalid request (SROC)
    When I request a valid new sroc bill run
     And I add an invalid sroc transaction to it
    Then I get a failed response

  Scenario: Making a valid request (PRESROC)
    When I request a valid new presroc bill run
     And I add a standard presroc transaction to it
    Then I get a successful response

  Scenario: Making an invalid request (PRESROC)
    When I request a valid new presroc bill run
     And I add an invalid presroc transaction to it
    Then I get a failed response

  Scenario: SRoC transactions are not accepted on a PreSRoC Bill Run
    When I request a valid new sroc bill run
     And I add a standard presroc transaction to it
    Then I get a failed response

  Scenario: PreSRoC transactions are not accepted on a SRoC Bill Run
    When I request a valid new presroc bill run
     And I add a standard sroc transaction to it
    Then I get a failed response

  Scenario: A client ID can only be used once (SROC)
    When I request a valid new sroc bill run
     And I add 2 standard sroc transactions to it with the same client IDs 
    Then I am told that the client ID must be unique

  Scenario: A client ID can only be used once (PRESROC)
    When I request a valid new presroc bill run
     And I add 2 standard presroc transactions to it with the same client IDs 
    Then I am told that the client ID must be unique