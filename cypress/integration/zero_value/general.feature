Feature: Zero Value General

  Background: Authenticate
    Given I am the "system" user 

  Scenario: Invoice net total of £0 is zero value invoice (SROC)
    When I request a valid new sroc bill run
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 0           |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| deminimisInvoice | zeroValueInvoice | 
      | false            | true             |  
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |