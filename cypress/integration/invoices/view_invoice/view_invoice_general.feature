Feature: View Invoice General

  Background: Authenticate
    Given I am the "system" user

  Scenario: Viewing the bill run summary (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful sroc standard transaction for customer CM00000001
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to view the invoice for CM00000001
