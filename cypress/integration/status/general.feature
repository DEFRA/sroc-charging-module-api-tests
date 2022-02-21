Feature: Status
@ignore
  Scenario: GET status
    Given I request the /status endpoint
    Then the status response is as expected

  Scenario: Billed status (SROC)
    When I am the "system" user
     And I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
     And bill run status is updated to "initialised"
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
    Then bill run status is updated to "billed" 

  Scenario: Billing not required status (SROC)
    When I am the "system" user
     And I request a valid new sroc bill run for region A
     And bill run status is updated to "initialised"
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 1.00        |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM01 | 1.00        |
     And bill run status is updated to "initialised"
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
    Then bill run status is updated to "billing_not_required"   
