Feature: Customer Changes General

  Background: Authenticate
    Given I am the "system" user

  Scenario: Making a valid customer change request
    When I make a valid customer change request
    Then I get a successful customer change response

  Scenario: Making an invalid customer change request
    When I make an invalid customer change request
    Then I get a failed response

  Scenario: Updating an existing change
    When I make a customer change request and follow it with another change for the same customer
    Then I get a successful customer change response
