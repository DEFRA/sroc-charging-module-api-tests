Feature: Calculate Charge General

  Background: Authenticate
    Given I am the "system" user

  Scenario: Making a valid SROC request
    When I make a valid sroc request
    Then I get a successful sroc response

  Scenario: Making a valid PRESROC request
    When I make a valid presroc request
    Then I get a successful presroc response

  Scenario: Making an invalid SROC request
    When I make an invalid sroc request
    Then I get a failed response
