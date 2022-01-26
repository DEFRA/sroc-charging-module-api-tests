Feature: Rebill Invoice General

  Background: Authenticate
    Given I am the "system" user
@ignore
  Scenario: Successfully rebill a debit invoice
     And I have a billed sroc bill run
    When I try to rebill a debit invoice to a new sroc bill run
    Then I get a successful response that includes details for the invoices created
@ignore
  Scenario: Successfully rebill a credit invoice 
     And I have a billed sroc bill run
    When I try to rebill a credit invoice to a new sroc bill run
    Then I get a successful response that includes details for the invoices created
@ignore
  Scenario: Successfully rebill a zero value invoice
     And I have a billed sroc bill run
    When I try to rebill a zeroValue invoice to a new sroc bill run
    Then I get a successful response that includes details for the invoices created
@ignore
  Scenario: Successfully rebill a deminimis invoice
     And I have a billed sroc bill run
    When I try to rebill a deminimis invoice to a new sroc bill run
    Then I get a successful response that includes details for the invoices created  
@ignore
  Scenario: Successfully rebill a minimum charge invoice (PRESROC)
     And I have a billed presroc bill run
    When I try to rebill a minimumCharge invoice to a new presroc bill run
    Then I get a successful response that includes details for the invoices created   
@ignore
  Scenario: Source invoice and destination bill run must be for the same region  
     And I have a billed sroc bill run
    When I try to rebill an invoice to a new sroc bill run for a different region
    Then I get a conflict response
     And I am told the source invoice region is different to the destination bill run region
@ignore
  Scenario: Source bill run and invoice must be same ruleset as destination billrun
     And I have a billed sroc bill run
    When I try to rebill it to a new presroc bill run
    Then I get a conflict response
  
  Scenario: Source bill run cannot be initialised
     And I have an initialised generated sroc bill run
    When I try to rebill it to a new sroc bill run
    Then I get a conflict response
     And I am told the source bill run region does not have a status of billed

@ignore
  Scenario: Source bill run cannot be generated
     And I have a generated sroc bill run
    When I try to rebill it to a new sroc bill run
    Then I get a conflict response
     And I am told the source bill run region does not have a status of billed
@ignore
  Scenario: Source bill run cannot be approved
     And I have an approved sroc bill run
    When I try to rebill it to a new sroc bill run
    Then I get a conflict response
     And I am told the source bill run region does not have a status of billed

@ignore
  Scenario: Destination bill run can be initialised
    When I try to rebill it to a new sroc bill run
    Then I get a successful response that includes details for the invoices created
@ignore
  Scenario: Destination bill run can be generated
    When I try to rebill it to a generated sroc bill run
    Then I get a successful response that includes details for the invoices created
@ignore
  Scenario: Destination bill run cannot be approved
    When I try to rebill it to an approved sroc bill run
    Then I get a failed response
@ignore
  Scenario: Destination bill run cannot be billed
    When I try to rebill it to a billed sroc bill run
    Then I get a conflict response

  #Scenario Rebilled invoice cannot be rebilled again

  #Scenario Deminimis and Minimum Charge invoices cannot be rebilled 