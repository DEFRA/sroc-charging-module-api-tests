Feature: View Invoice General

  Background: Authenticate
    Given I am the "system" user

  Scenario: Debit invoice level items are correct (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to view the invoice for CM00000001
    Then the invoice level items are correct for a debit invoice
     And the licence level items are correct
     And the transaction level items are correct

  Scenario: Credit invoice level items are correct (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to view the invoice for CM00000001
    Then the invoice level items are correct for a credit invoice
     And the licence level items are correct
     And the transaction level items are correct   

  Scenario: Deminimis invoice level items are correct (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 8.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to view the invoice for CM00000001
    Then the invoice level items are correct for a deminimis invoice
     And the licence level items are correct
     And the transaction level items are correct

  Scenario: Deminimis invoice level items are correct (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 3.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to view the invoice for CM00000001
    Then the invoice level items are correct for a deminimis invoice
     And the licence level items are correct
     And the transaction level items are correct

  Scenario: Zero value invoice level items are correct (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 8.00        |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM01 | 8.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to view the invoice for CM00000001
    Then the invoice level items are correct for a zeroValue invoice
     And the licence level items are correct
     #And the transaction level items are correct
     
  Scenario: Minimum Charge invoice level items are correct (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | minimumCharge   | presroc | CM00000001  | LIC/NUM/CM01 | 22.00       |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to view the invoice for CM00000001
    Then the invoice level items are correct for a minimumCharge invoice
     And the licence level items are correct
     #And the transaction level items are correct    