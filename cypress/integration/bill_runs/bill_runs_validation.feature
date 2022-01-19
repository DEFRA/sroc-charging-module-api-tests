Feature: Bill runs validation

  Background: Authenticate
    Given I am the "system" user

  Scenario: Bill run approval request errors if bill run status is already approved (SROC)
    When I request a valid new sroc bill run
     And I add a standard sroc transaction to it
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I attempt to request to approve the bill run
    Then I am told the bill run status must be "generated"  

  Scenario: Bill run approval request errors if bill run status is already approved (PRESROC)
    When I request a valid new presroc bill run
     And I add a standard presroc transaction to it
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I attempt to request to approve the bill run
    Then I am told the bill run status must be "generated"  

  Scenario: Bill run without transactions cannot be approved (SROC)
    When I request a valid new sroc bill run
     And I attempt to request to approve the bill run
    Then I am told the bill run status must be "generated"

  Scenario: Bill run without transactions cannot be approved (PRESROC)
    When I request a valid new presroc bill run
     And I attempt to request to approve the bill run
    Then I am told the bill run status must be "generated"  