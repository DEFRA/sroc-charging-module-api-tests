Feature: Send Bill Run

  Background: Authenticate
    Given I am the "system" user

  Scenario: Debit Bill run is sent successfully (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | credit          | sroc    | CM00000002  | LIC/NUM/CM02 | 100.00      |
      | standard        | sroc    | CM00000003  | LIC/NUM/CM03 | 70.00       |
      | standard        | sroc    | CM00000004  | LIC/NUM/CM04 | 8.00        |
      | standard        | sroc    | CM00000005  | LIC/NUM/CM05 | 100.00      |
      | credit          | sroc    | CM00000005  | LIC/NUM/CM05 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
    Then bill run status is updated to "billed"
     And I request to view the bill run
     And the transaction reference is generated for CM00000001
     And the transaction reference is generated for CM00000002
     And the transaction reference is generated for CM00000003
     And the transaction reference is generated for CM00000004
     And a transaction reference is not generated for CM00000005

  Scenario: Credit Bill run is sent successfully (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | sroc    | CM00000002  | LIC/NUM/CM02 | 100.00      |
      | credit          | sroc    | CM00000003  | LIC/NUM/CM03 | 70.00       |
      | credit          | sroc    | CM00000004  | LIC/NUM/CM04 | 8.00        |
      | credit          | sroc    | CM00000005  | LIC/NUM/CM05 | 100.00      |
      | standard        | sroc    | CM00000005  | LIC/NUM/CM05 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
    Then bill run status is updated to "billed"
     And I request to view the bill run
     And the transaction reference is generated for CM00000001
     And the transaction reference is generated for CM00000002
     And the transaction reference is generated for CM00000003
     And the transaction reference is generated for CM00000004
     And a transaction reference is not generated for CM00000005   

  Scenario: Bill run with net total of 0 is sent successfully (SROC)
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

  Scenario: Bill run made up of deminimis invoices is sent (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 9.00        |
      | standard        | sroc    | CM00000002  | LIC/NUM/CM03 | 8.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
    Then bill run status is updated to "billed"
     And I request to view the bill run
     And the transaction reference is generated for CM00000001
     And the transaction reference is generated for CM00000002

  Scenario: Bill run made up of zero value invoices is not sent (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 180.00      |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM02 | 180.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
    Then bill run status is updated to "billing_not_required"
     And I request to view the bill run
     And a transaction reference is not generated for CM00000001 

  Scenario: A Bill run without approved status cannot be sent (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 180.00      |
    Then I request to send an unapproved bill run I am told the bill run does not have status of approved 
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to send an unapproved bill run I am told the bill run does not have status of approved

  Scenario: A sent Bill run cannot be sent again (SROC)
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
    Then I request to send the bill run and I am told it cannot be updated because its billed

  Scenario: Debit Bill run is sent successfully (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | credit          | presroc | CM00000002  | LIC/NUM/CM02 | 100.00      |
      | standard        | presroc | CM00000003  | LIC/NUM/CM03 | 70.00       |
      | standard        | presroc | CM00000004  | LIC/NUM/CM04 | 3.00        |
      | standard        | presroc | CM00000005  | LIC/NUM/CM05 | 100.00      |
      | credit          | presroc | CM00000005  | LIC/NUM/CM05 | 100.00      |
      | minimumCharge   | presroc | CM00000006  | LIC/NUM/CM06 | 12.00       |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
    Then bill run status is updated to "billed"
     And I request to view the bill run
     And the transaction reference is generated for CM00000001
     And the transaction reference is generated for CM00000002
     And the transaction reference is generated for CM00000003
     And a transaction reference is not generated for CM00000004
     And a transaction reference is not generated for CM00000005
     And the transaction reference is generated for CM00000006

  Scenario: Credit Bill run is sent successfully (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType     | ruleset | customerRef | licenceNum   | chargeValue |
      | credit              | presroc | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard            | presroc | CM00000002  | LIC/NUM/CM02 | 100.00      |
      | credit              | presroc | CM00000003  | LIC/NUM/CM03 | 70.00       |
      | credit              | presroc | CM00000004  | LIC/NUM/CM04 | 8.00        |
      | credit              | presroc | CM00000005  | LIC/NUM/CM05 | 100.00      |
      | standard            | presroc | CM00000005  | LIC/NUM/CM05 | 100.00      |
      | creditMinimumCharge | presroc | CM00000006  | LIC/NUM/CM06 | 12.00       |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
    Then bill run status is updated to "billed"
     And I request to view the bill run
     And the transaction reference is generated for CM00000001
     And the transaction reference is generated for CM00000002
     And the transaction reference is generated for CM00000003
     And the transaction reference is generated for CM00000004
     And a transaction reference is not generated for CM00000005
     And the transaction reference is generated for CM00000006

  Scenario: Bill run with net total of 0 is sent successfully (PRESROC)
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

  Scenario: Bill run made up of zero value or deminimis invoices is not sent (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 180.00      |
      | credit          | presroc | CM00000001  | LIC/NUM/CM02 | 180.00      |
      | standard        | presroc | CM00000002  | LIC/NUM/CM03 | 4.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to approve the bill run
     And bill run status is updated to "approved"
     And I request to send the bill run
    Then bill run status is updated to "billing_not_required"
     And I request to view the bill run
     And a transaction reference is not generated for CM00000001
     And a transaction reference is not generated for CM00000002

  Scenario: A Bill run without approved status cannot be sent (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 180.00      |
    Then I request to send an unapproved bill run I am told the bill run does not have status of approved 
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to send an unapproved bill run I am told the bill run does not have status of approved

  Scenario: A sent Bill run cannot be sent again (PRESROC)
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
    Then I request to send the bill run and I am told it cannot be updated because its billed  