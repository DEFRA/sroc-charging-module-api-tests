Feature: Create a Bill Run
  #CMEA-89

  Background: Authenticate
    Given I am the "system" user

  #AC1
  Scenario Outline: Create bill run accepts a rule set flag
    When I request a valid new <ruleset> bill run for <region>
    Then the bill run ID and number are returned

    Examples:
      | ruleset | region |
      | presroc | A      |
      | sroc    | A      |

  #AC3
  Scenario: The ruleset flag is not mandatory
    When I request a valid new sroc bill run
    Then the bill run ID and number are returned

  Scenario Outline: Create bill run accepts a region flag
    When I request a valid new <ruleset> bill run for <region>
    Then the bill run ID and number are returned

    Examples:
      | ruleset | region |
      | presroc | A      |
      | presroc | B      |
      | presroc | E      |
      | presroc | N      |
      | presroc | S      |
      | presroc | T      |
      | presroc | W      |
      | presroc | Y      |
      | sroc    | A      |
      | sroc    | B      |
      | sroc    | E      |
      | sroc    | N      |
      | sroc    | S      |
      | sroc    | T      |
      | sroc    | W      |
      | sroc    | Y      |

  Scenario: Bill run numbers are issued in ascending order
    When I request a valid new sroc bill run
    And I request another valid new sroc bill run
    Then the bill run numbers are issued in ascending order

  #AC2
  Scenario Outline: Acceptable values of the ruleset flag are presroc & sroc
    When I request an invalid new <ruleset> bill run for <region>
    Then I am told that acceptable values are presroc or sroc

    Examples:
      | ruleset  | region |
      | Presroc  | A      |
      | PreSRoC  | A      |
      | pre-sroc | A      |
      | prsric   | A      |
      | Sroc     | A      |
      | SRoC     | A      |
      | srocc    | A      |
      | a        | A      |

  Scenario: The region flag is mandatory
    When I request an invalid new bill run
    Then I am told that region is required

  Scenario Outline: Acceptable values of the region flag are A, B, E, N, S, T, W and Y
    When I request an invalid new <ruleset> bill run for <region>
    Then I am told that region must be one of A, B, E, N, S, T, W, Y

    Examples:
      | ruleset | region |
      | presroc | G      |
      | presroc | 123    |

  Scenario: The Bill Run does not contain any transactions when created
    When I request a valid new sroc bill run
    Then the bill run does not contain any transactions
