Feature: Transaction Reference General

  Background: Authenticate
    Given I am the "system" user

  Scenario: Transaction Reference is generated
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
     And bill run status is updated to "billed"
     And I request to view the bill run 
    Then the transaction reference is generated for CM00000001

  Scenario: Transaction Reference is correct format for a Debit invoice (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 180.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
     And bill run status is updated to "billed"
     And I request to view the bill run
     And I request to view the invoice for CM00000001
    Then the transaction reference is the correct format for CM00000001

  Scenario: Transaction Reference is correct format for a Credit invoice (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM01 | 180.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
     And bill run status is updated to "billed"
     And I request to view the bill run
     And I request to view the invoice for CM00000001
    Then the transaction reference is the correct format for CM00000001
@ignore
  Scenario: Transaction Reference is correct format for a Deminimis invoice (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 8.00        |
      | credit          | sroc    | CM00000003  | LIC/NUM/CM03 | 180.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
     And bill run status is updated to "billed"
     And I request to view the bill run
     And I request to view the invoice for CM00000001
    Then the transaction reference is the correct format for CM00000001

  Scenario: Transaction Reference is correct format for a Zero value invoice (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 180.00      |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM02 | 180.00      |
      | standard        | sroc    | CM00000002  | LIC/NUM/CM02 | 150.00      |
      | standard        | sroc    | CM00000003  | LIC/NUM/CM03 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
     And bill run status is updated to "billed"
     And I request to view the bill run
     And I request to view the invoice for CM00000001
    Then the transaction reference is the correct format for CM00000001

  Scenario: Transaction Reference is correct format for a Debit invoice (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 180.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
     And bill run status is updated to "billed"
     And I request to view the bill run
     And I request to view the invoice for CM00000001
    Then the transaction reference is the correct format for CM00000001

  Scenario: Transaction Reference is correct format for a Credit invoice (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | presroc | CM00000001  | LIC/NUM/CM01 | 180.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
     And bill run status is updated to "billed"
     And I request to view the bill run
     And I request to view the invoice for CM00000001
    Then the transaction reference is the correct format for CM00000001

  Scenario: Transaction Reference is correct format for a Deminimis invoice (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 8.00        |
      | credit          | presroc | CM00000003  | LIC/NUM/CM03 | 180.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
     And bill run status is updated to "billed"
     And I request to view the bill run
     And I request to view the invoice for CM00000001
    Then the transaction reference is the correct format for CM00000001

  Scenario: Transaction Reference is correct format for a Zero value invoice (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 180.00      |
      | credit          | presroc | CM00000001  | LIC/NUM/CM02 | 180.00      |
      | standard        | presroc | CM00000002  | LIC/NUM/CM02 | 150.00      |
      | standard        | presroc | CM00000003  | LIC/NUM/CM03 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
     And bill run status is updated to "billed"
     And I request to view the bill run
     And I request to view the invoice for CM00000001
    Then the transaction reference is the correct format for CM00000001