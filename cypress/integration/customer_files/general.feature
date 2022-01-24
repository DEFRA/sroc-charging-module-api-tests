Feature: Customer Files General

  Background: Authenticate
    Given I am the "system" user

  Scenario: Listing customer files
    When I make a valid customer files request
    Then I get a successful customer files response
