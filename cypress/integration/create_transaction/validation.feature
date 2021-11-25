Feature: Create Transaction Validation

  Background: Authenticate
    Given I am the "system" user

  Scenario: Checks for mandatory values (required in all requests)
    When I request a valid new sroc bill run
     And I do not send the following values I get the expected response
      | sroc     | chargeCategoryCode        |
      | sroc     | periodStart               |
      | sroc     | authorisedDays            |
      | sroc     | billableDays              |
      | sroc     | winterOnly                |
      | sroc     | section130Agreement       |
      | sroc     | section127Agreement       |
      | sroc     | twoPartTariff             |
      | sroc     | compensationCharge        |
      | sroc     | waterCompanyCharge        |
      | sroc     | supportedSource           |
      | sroc     | loss                      |
      | sroc     | authorisedVolume          |
      | sroc     | credit                    |
      | sroc     | periodStart               |
      | sroc     | periodEnd                 |
      | sroc     | region                    |
      | sroc     | customerReference         |
      | sroc     | licenceNumber             |
      | sroc     | chargePeriod              |
      | sroc     | areaCode                  |
      | sroc     | lineDescription           |
      | sroc     | chargeCategoryDescription |

  Scenario: Checks for mandatory values when compensationCharge is true (SROC)
    When I request a valid new sroc bill run
     And I send a sroc request where compensationCharge is true
    Then If I do not send the following values I get the expected response
      | regionalChargingArea |
      | waterUndertaker      |

  Scenario: Checks for mandatory values when compensationCharge is true (PRESROC)
    When I request a valid new presroc bill run
     And I send a presroc request where compensationCharge is true
    Then If I do not send the following values I get the expected response
      | eiucSource           |
      | waterUndertaker      |

  Scenario: Checks for mandatory values when twoPartTariff is true
    When I request a valid new sroc bill run
     And I send a sroc request where twoPartTariff is true
    Then If I do not send the following values I get the expected response
      | actualVolume |

  Scenario: Checks for mandatory values when supportedSource is true
    When I request a valid new sroc bill run
     And I send a sroc request where supportedSource is true
    Then If I do not send the following values I get the expected response
      | supportedSourceName |

@ignore
##This cannot be tested until View bill run endpoint becomes available
  Scenario: Sets default values
    When I request a valid new sroc bill run
     And I do not send the following values the CM sets the correct default
      | sroc    | abatementFactor     | 1.0 |
      | sroc    | aggregateProportion | 1.0 |
      | presroc | section126Factor    | 1.0 |

  Scenario: Checks data types of values (SROC)
    When I request a valid new sroc bill run
     And I send the following properties with the wrong data types I am told what they should be
      | sroc    | winterOnly          | boolean |
      | sroc    | section130Agreement | boolean |
      | sroc    | section127Agreement | boolean |
      | sroc    | twoPartTariff       | boolean |
      | sroc    | compensationCharge  | boolean |
      | sroc    | waterCompanyCharge  | boolean |
      | sroc    | supportedSource     | boolean |
      | sroc    | credit              | boolean |
      | sroc    | waterUndertaker     | boolean |
      | sroc    | abatementFactor     | number  |
      | sroc    | aggregateProportion | number  |
      | sroc    | authorisedDays      | number  |
      | sroc    | billableDays        | number  |
      | sroc    | authorisedVolume    | number  |
      | sroc    | actualVolume        | number  |

  Scenario: Checks data types of values (PRESROC)
    When I request a valid new presroc bill run
     And I send the following properties with the wrong data types I am told what they should be
      | presroc | section130Agreement | boolean |
      | presroc | section127Agreement | boolean |
      | presroc | twoPartTariff       | boolean |
      | presroc | compensationCharge  | boolean |
      | presroc | credit              | boolean |
      | presroc | authorisedDays      | number  |
      | presroc | billableDays        | number  |
      | presroc | section126Factor    | number  |
      | presroc | volume              | number  |    