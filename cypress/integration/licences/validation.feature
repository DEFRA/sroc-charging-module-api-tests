Feature: Delete Licence Validation

  Background: Authenticate
    Given I am the "system" user

  Scenario: Delete licence unsuccessfully with unknown invoice ID (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the licence with an unknown licence ID and I am told its unknown

  Scenario: Delete licence unsuccessfully with licence ID that is not part of current bill run (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request another valid new sroc bill run
    Then I request to delete the licence LIC/NUM/CM01 for CM00000001 and I am told its not linked to this bill run

  Scenario: Licence cannot be deleted if its part of an approved or sent bill run (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to approve the bill run
     And bill run status is updated to "approved"
    Then I request to delete the licence LIC/NUM/CM01 for CM00000001 and I am told the bill run cannot be edited because its status is approved
     And I request to send the bill run
     And bill run status is updated to "billed"
    Then I request to delete the licence LIC/NUM/CM01 for CM00000001 and I am told the bill run cannot be edited because its status is billed

  Scenario: Delete licence unsuccessfully with unknown invoice ID (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset    | customerRef | licenceNum   | chargeValue |
      | standard        | presroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the licence with an unknown licence ID and I am told its unknown

  Scenario: Delete licence unsuccessfully with licence ID that is not part of current bill run (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset    | customerRef | licenceNum   | chargeValue |
      | standard        | presroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request another valid new presroc bill run
    Then I request to delete the licence LIC/NUM/CM01 for CM00000001 and I am told its not linked to this bill run

  Scenario: Licence cannot be deleted if its part of an approved or sent bill run (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset    | customerRef | licenceNum   | chargeValue |
      | standard        | presroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to approve the bill run
     And bill run status is updated to "approved"
    Then I request to delete the licence LIC/NUM/CM01 for CM00000001 and I am told the bill run cannot be edited because its status is approved
     And I request to send the bill run
     And bill run status is updated to "billed"
    Then I request to delete the licence LIC/NUM/CM01 for CM00000001 and I am told the bill run cannot be edited because its status is billed