Feature: Calculate Charge General

  Background: Authenticate
    Given I am the "system" user

  Scenario: Making a valid SROC debit request
    When I make a valid sroc debit request
    Then I get a successful sroc debit response

  Scenario: Making a valid PRESROC debit request
    When I make a valid presroc debit request
    Then I get a successful presroc debit response

  Scenario: Making a valid SROC credit request
    When I make a valid sroc credit request
    Then I get a successful sroc credit response

  Scenario: Making a valid PRESROC credit request
    When I make a valid presroc credit request
    Then I get a successful presroc credit response

  Scenario: Making an invalid SROC request
    When I make an invalid sroc request
    Then I get a failed response

  Scenario: Check that PRESROC section127Agreement is correctly returned
    When I make a valid presroc request with section127Agreement set to true
    Then I get a successful response that includes chargeElementAgreement populated
