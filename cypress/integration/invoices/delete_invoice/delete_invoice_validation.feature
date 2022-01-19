Feature: Delete Invoice Validation

  Background: Authenticate
    Given I am the "system" user

  Scenario: Delete invoice unsuccessfully with unknown invoice ID (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice with an unknown invoice ID and I am told its unknown

  Scenario: Delete invoice unsuccessfully with invoice ID that is not part of current bill run (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request another valid new sroc bill run
    Then I request to delete the invoice for CM00000001 and I am told its not linked to this bill run 

  Scenario: Delete invoice unsuccessfully with unknown invoice ID (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | C M00000001  | LIC/NUM/CM01 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice with an unknown invoice ID and I am told its unknown

  Scenario: Delete invoice unsuccessfully with invoice ID that is not part of current bill run (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request another valid new sroc bill run
    Then I request to delete the invoice for CM00000001 and I am told its not linked to this bill run 
