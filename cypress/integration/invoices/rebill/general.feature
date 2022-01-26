Feature: Rebill Invoice General

  Background: Authenticate
    Given I am the "system" user
    And I have a billed sroc bill run


  Scenario: Successfully rebill a debit invoice
    When I try to rebill a debit invoice to a new sroc bill run
    Then I get a successful response that includes details for the invoices created

  #Scenario: Successfully rebill a credit invoice 

  #Scenario: Successfully rebill a zero value invoice 

  #Scenario: Source invoice must be billed

  #Scenario: Source bill run must be billed   

  #Scenario: Source invoice and destination bill run must be for the same region
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