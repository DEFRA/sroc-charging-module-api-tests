Feature: Regimes

  Background: Authenticate
    Given I am the "admin" user

  Scenario: Listing regimes
    When I request a list of all regimes
    Then a summary of all regimes is returned

  Scenario: Viewing a regime
    When I request to view a regime
    Then details of the regime are returned
