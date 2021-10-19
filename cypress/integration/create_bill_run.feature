Feature: Create a Bill Run 
#CMEA-89

  Background: Authenticate
    Given I am the 'system' user

#AC1
  Scenario: Creating a Pre-SRoC Bill Run
    When I request a valid new presroc bill run
    Then the bill run ID and number are returned

#AC1
  Scenario: Creating a SRoC Bill Run
    When I request a valid new sroc bill run
    Then the bill run ID and number are returned 

#AC3
  Scenario: The ruleset flag is not mandatory
    When I request a valid new bill run
    Then the bill run ID and number are returned 

#AC2
  Scenario Outline: Acceptable values of the ruleset flag are presroc & sroc
    When I request an invalid new <ruleset> bill run
    Then I am told that acceptable values are Pre-SRoC or SRoC

    Examples:
    | ruleset  |
    | Presroc  |
    | PreSRoC  |
    | pre-sroc |
    | prsric   |
    | Sroc     |
    | SRoC     |
    | srocc    |
    | a        |