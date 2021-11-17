Feature: Calculate Charge General

  Background: Authenticate
    Given I am the "system" user

  @wip
  Scenario: Making a valid request
    When I make a valid request
    Then I get a successful response

  @wip
  Scenario: Making an invalid request
    When I make an invalid request
    Then I get a failed response
