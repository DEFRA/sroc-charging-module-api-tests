Feature: Rebill Invoice General

  Background: Authenticate
    Given I am the "system" user

  Scenario: Successfully rebill a debit invoice
     And I have a billed sroc bill run
    When I try to rebill a debit invoice to a new sroc bill run
    Then I get a successful response that includes details for the invoices created
     And I request to send the rebill bill run

  Scenario: Successfully rebill a credit invoice 
     And I have a billed sroc bill run
    When I try to rebill a credit invoice to a new sroc bill run
    Then I get a successful response that includes details for the invoices created
     And I request to send the rebill bill run

  Scenario: Successfully rebill a zero value invoice
     And I have a billed sroc bill run
    When I try to rebill a zeroValue invoice to a new sroc bill run
    Then I get a successful response that includes details for the invoices created

  Scenario: Successfully rebill a deminimis invoice
     And I have a billed sroc bill run
    When I try to rebill a deminimis invoice to a new sroc bill run
    Then I get a successful response that includes details for the invoices created  

  Scenario: Successfully rebill a minimum charge invoice (PRESROC)
     And I have a billed presroc bill run
    When I try to rebill a minimumCharge invoice to a new presroc bill run
    Then I get a successful response that includes details for the invoices created   
     And I request to send the rebill bill run

  Scenario: Source invoice and destination bill run must be for the same region  
     And I have a billed sroc bill run
    When I try to rebill an invoice to a new sroc bill run for a different region
    Then I get a conflict response
     And I am told the source invoice region is different to the destination bill run region

  Scenario: Source bill run and invoice must be same ruleset as destination billrun
     And I have a billed sroc bill run
    When I try to rebill it to a new presroc bill run
    Then I get a conflict response

  Scenario: Source bill run cannot be initialised
     And I have an initialised sroc bill run
    When I try to rebill it to a new sroc bill run
    Then I get a conflict response
     And I am told the source bill run region does not have a status of billed

  Scenario: Source bill run cannot be generated
     And I have a generated sroc bill run
    When I try to rebill it to a new sroc bill run
    Then I get a conflict response
     And I am told the source bill run region does not have a status of billed

  Scenario: Source bill run cannot be approved
     And I have an approved sroc bill run
    When I try to rebill it to a new sroc bill run
    Then I get a conflict response
     And I am told the source bill run region does not have a status of billed

  Scenario: Destination bill run can be initialised
     And I have a billed sroc bill run
    When I try to rebill it to an initialised sroc bill run
    Then I get a successful response that includes details for the invoices created

  Scenario: Destination bill run can be generated
     And I have a billed sroc bill run
    When I try to rebill it to a generated sroc bill run
    Then I get a successful response that includes details for the invoices created

  Scenario: Destination bill run cannot be approved
     And I have a billed sroc bill run
    When I try to rebill it to an approved sroc bill run
    Then I get a conflict response

  Scenario: Destination bill run cannot be billed
     And I have a billed sroc bill run
    When I try to rebill it to a billed sroc bill run
    Then I get a conflict response

  Scenario: Rebilled source invoice cannot be rebilled again
     And I have a billed sroc bill run
    When I try to rebill it to a new sroc bill run
    Then I get a successful response that includes details for the invoices created
     And I try to rebill the same invoice to the same new sroc bill run
    Then I get a conflict response
     And I am told the source invoice has already been rebilled

  Scenario: Rebilled source invoice cannot be rebilled again (to a new bill run)
     And I have a billed sroc bill run
    When I try to rebill it to a new sroc bill run
    Then I get a successful response that includes details for the invoices created
     And I try to rebill the same invoice to a new sroc bill run
    Then I get a conflict response
     And I am told the source invoice has already been rebilled

  Scenario: Rebilled source invoice that has been deleted can be rebilled
     And I have a billed sroc bill run
    When I try to rebill it to a new sroc bill run
    Then I get a successful response that includes details for the invoices created
     And I request to delete the C rebill invoice
     And I request to delete the R rebill invoice
     And I try to rebill it again
    Then I get a successful response that includes details for the invoices created 

  Scenario: Cancel (C) invoice cannot be rebilled
     And I have a billed sroc bill run
    When I try to rebill it to a new sroc bill run
    Then I get a successful response that includes details for the invoices created
     And I request the new destination bill run to be billed
     And I try to rebill the cancel invoice to a new sroc bill run
    Then I am told a rebill cancel invoice cannot be rebilled

  Scenario: Rebill (R) invoice can be rebilled
     And I have a billed sroc bill run
    When I try to rebill it to a new sroc bill run
    Then I get a successful response that includes details for the invoices created
     And I request the new destination bill run to be billed
     And I try to rebill the rebill invoice to a new sroc bill run
    Then I get a successful response that includes details for the invoices created

  Scenario: All transactions are copied over into rebill C and R invoices
     And I have a billed sroc bill run
    When I try to rebill it to a new sroc bill run
    Then I get a successful response that includes details for the invoices created
     And the credit C invoice includes all transactions
     And the rebill R invoice includes all transactions

  Scenario: C and R invoices reference the source invoice ID
     And I have a billed sroc bill run
    When I try to rebill it to a new sroc bill run
    Then I get a successful response that includes details for the invoices created
     And the credit C invoice includes the source invoice ID
     And the rebill R invoice includes the source invoice ID

  Scenario: C and R transactions reference the source transaction ID
     And I have a billed sroc bill run
    When I try to rebill it to a new sroc bill run
    Then I get a successful response that includes details for the invoices created
     And the credit C transaction includes the source transaction ID
     And the rebill R transaction includes the source transaction ID   

  Scenario: Transactions cannot be added to rebill invoices
     And I have a billed sroc bill run
     And I try to rebill a debit invoice to a new sroc bill run
     And I get a successful response that includes details for the invoices created
    When I try to add a standard sroc transaction to rebill invoices
    Then a new invoice is created