Feature: View Invoice General

  Background: Authenticate
    Given I am the "system" user

  Scenario: Viewing the bill run summary (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 2500.00     |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to view the invoice for CM00000001
    Then the invoice level items are correct
