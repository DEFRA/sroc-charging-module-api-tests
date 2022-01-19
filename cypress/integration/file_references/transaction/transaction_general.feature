Feature: Transaction File Reference General

  Background: Authenticate
    Given I am the "system" user

  Scenario: Transaction File Reference is generated
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
    Then the transaction file reference is generated

  Scenario: Transaction File Reference is correct format for a Bill Run (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 180.00      |
      | credit          | sroc    | CM00000002  | LIC/NUM/CM02 | 100.00      |
      | standard        | sroc    | CM00000003  | LIC/NUM/CM03 | 70.00       |
      | standard        | sroc    | CM00000004  | LIC/NUM/CM04 | 8.00        |
      | standard        | sroc    | CM00000005  | LIC/NUM/CM05 | 900.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
     And bill run status is updated to "billed"
     And I request to view the bill run
    Then the transaction file reference is the correct format

  Scenario: Transaction File Reference is correct format for a Bill Run with net total of 0 (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 180.00      |
      | credit          | sroc    | CM00000002  | LIC/NUM/CM02 | 180.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
     And bill run status is updated to "billed"
     And I request to view the bill run
    Then the transaction file reference is the correct format

  Scenario: Transaction File Reference is not generated for Bill Run with billing_not_required (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 180.00      |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM02 | 180.00      |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 8.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
     And bill run status is updated to "billing_not_required"
     And I request to view the bill run
    Then the transaction file reference is the correct format  

  Scenario: Transaction File Reference is correct format for a Bill Run (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 180.00      |
      | credit          | presroc | CM00000002  | LIC/NUM/CM02 | 100.00      |
      | standard        | presroc | CM00000003  | LIC/NUM/CM03 | 70.00       |
      | standard        | presroc | CM00000004  | LIC/NUM/CM04 | 8.00        |
      | standard        | presroc | CM00000005  | LIC/NUM/CM05 | 900.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
     And bill run status is updated to "billed"
     And I request to view the bill run
    Then the transaction file reference is the correct format

  Scenario: Transaction File Reference is correct format for a Bill Run with net total of 0 (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 180.00      |
      | credit          | presroc | CM00000002  | LIC/NUM/CM02 | 180.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
     And bill run status is updated to "billed"
     And I request to view the bill run
    Then the transaction file reference is the correct format

  Scenario: Transaction File Reference is not generated for Bill Run with billing_not_required (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 180.00      |
      | credit          | presroc | CM00000001  | LIC/NUM/CM02 | 180.00      |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 4.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
     And bill run status is updated to "billing_not_required"
     And I request to view the bill run
    Then the transaction file reference is the correct format  