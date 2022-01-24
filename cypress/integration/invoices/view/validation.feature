Feature: View Invoice Validation

  Background: Authenticate
    Given I am the "system" user

  Scenario: Invoice ID is unknown
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to view the invoice with an unknown invoice ID and I am told its unknown

  Scenario: Invoice ID is not part of this Bill run
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request another valid new sroc bill run
    Then I request to view the invoice for CM00000001 and I am told its not linked to this bill run 