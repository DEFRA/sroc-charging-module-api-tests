Feature: Bill runs

  Background: Authenticate
    Given I am the "system" user

  Scenario: Initialised bill runs can be deleted
    And I request a valid new sroc bill run
    And I add a standard sroc transaction to it
    And bill run status is updated to "initialised"
    And I request to delete the bill run
   Then bill run is not found
  
  Scenario: Generated bill runs can be deleted
    And I request a valid new sroc bill run
    And I add a standard sroc transaction to it
    And I request to generate the bill run
    And bill run status is updated to "generated"
    And I request to delete the bill run
   Then bill run is not found

  Scenario: Approved bill runs cannot be deleted
    And I request a valid new sroc bill run
    And I add a standard sroc transaction to it
    And I request to generate the bill run
    And bill run status is updated to "generated"
    And I request to approve the bill run
    And bill run status is updated to "approved"
   When I try to delete the bill run
   Then I am told the bill run cannot be deleted because its approved 
  
  Scenario: Billed bill runs cannot be deleted
    And I request a valid new sroc bill run
    And I add a standard sroc transaction to it
    And I request to generate the bill run
    And bill run status is updated to "generated"
    And I request to approve the bill run
    And bill run status is updated to "approved"
    And I request to send the bill run
    And bill run status is updated to "billed"
   When I try to delete the bill run
   Then I am told the bill run cannot be deleted because its billed

  Scenario: Billed bill with the status of billing_not_required cannot be deleted
    And I request a valid new sroc bill run
    And I add a deminimis sroc transaction to it
    And I request to generate the bill run
    And bill run status is updated to "generated"
    And I request to approve the bill run
    And bill run status is updated to "approved"
    And I request to send the bill run
    And bill run status is updated to "billing_not_required"
   When I try to delete the bill run
   Then I am told the bill run cannot be deleted because its billing not required