Feature: Rebill Invoice General

  Background: Authenticate
    Given I am the "system" user
    And I have a billed sroc bill run

  Scenario: Destination bill run can be initialised
    When I try to rebill it to a new sroc bill run
    Then I get a successful response that includes details for the invoices created

  Scenario: Destination bill run can be generated
    When I try to rebill it to a generated sroc bill run
    Then I get a successful response that includes details for the invoices created

  Scenario: Destination bill run cannot be approved
    When I try to rebill it to an approved sroc bill run
    Then I get a failed response

  Scenario: Destination bill run cannot be billed
    When I try to rebill it to a billed sroc bill run
    Then I get a conflict response
