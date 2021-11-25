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
      | sroc | winterOnly          | boolean |
      | sroc | section130Agreement | boolean |
      | sroc | section127Agreement | boolean |
      | sroc | twoPartTariff       | boolean |
      | sroc | compensationCharge  | boolean |
      | sroc | waterCompanyCharge  | boolean |
      | sroc | supportedSource     | boolean |
      | sroc | credit              | boolean |
      | sroc | waterUndertaker     | boolean |
      | sroc | abatementFactor     | number  |
      | sroc | aggregateProportion | number  |
      | sroc | authorisedDays      | number  |
      | sroc | billableDays        | number  |
      | sroc | authorisedVolume    | number  |
      | sroc | actualVolume        | number  |

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

  Scenario: Checks integer data properties are not sent as decimals (SROC)
    When I request a valid new sroc bill run
     And I send the following properties as decimals I am told they should be integers
      | sroc | authorisedDays |
      | sroc | billableDays   |

  Scenario: Checks integer data properties are not sent as decimals (PRESROC)
    When I request a valid new presroc bill run
     And I send the following properties as decimals I am told they should be integers    
      | presroc | authorisedDays |
      | presroc | billableDays   |

  Scenario: Allows decimal values in number data properties (SROC)
    When I request a valid new sroc bill run
     And I send the following properties as decimals creates the transaction without error
      | sroc | abatementFactor     | number  |
      | sroc | aggregateProportion | number  |
      | sroc | authorisedVolume    | number  |
      | sroc | actualVolume        | number  |

  Scenario: Allows decimal values in number data properties (PRESROC)
    When I request a valid new presroc bill run
     And I send the following properties as decimals creates the transaction without error    
      | presroc | section126Factor    | number  |
      | presroc | volume              | number  |

  Scenario: Checks data values are not below the minimum expected (SROC)
    When I request a valid new sroc bill run
     And I send the following properties at less than their minimum I am told what they should be
      | sroc    | authorisedDays   | 0 | = |
      | sroc    | billableDays     | 0 | = |
      | sroc    | authorisedVolume | 0 | > |
      | sroc    | actualVolume     | 0 | > |

  Scenario: Checks data values are not below the minimum expected (PRESROC)
    When I request a valid new presroc bill run
     And I send the following properties at less than their minimum I am told what they should be  
      | presroc | authorisedDays   | 0 | = |
      | presroc | billableDays     | 0 | = |
      | presroc | volume           | 0 | = |

  Scenario: Checks data values are not above the maximum expected (SROC)
    When I request a valid new sroc bill run
     And I send the following properties at more than their maximum I am told what they should be
      | sroc    | authorisedDays   | 366 |
      | sroc    | billableDays     | 366 |

  Scenario: Checks data values are not above the maximum expected (PRESROC)
    When I request a valid new presroc bill run
     And I send the following properties at more than their maximum I am told what they should be    
      | presroc | authorisedDays   | 366 |
      | presroc | billableDays     | 366 |
  
  Scenario: Check period start and end dates fall in the same financial year (SROC)
    When I request a valid new sroc bill run
     And I send the following period start and end dates I am told what financial year periodEnd must be
      | sroc    | 01-APR-2022 | 01-APR-2023 | 2022 |
      | sroc    | 31-MAR-2023 | 01-APR-2023 | 2022 |

  Scenario: Check period start and end dates fall in the same financial year (PRESROC)
    When I request a valid new presroc bill run
     And I send the following period start and end dates I am told what financial year periodEnd must be    
      | presroc | 01-APR-2020 | 01-APR-2021 | 2020 |
      | presroc | 31-MAR-2021 | 01-APR-2021 | 2020 |

  Scenario: Checks that periodStart is less than or equal to periodEnd (SROC)
    When I request a valid new sroc bill run
     And I send the following period dates I am told that periodStart must be less than or equal to periodEnd
      | sroc    | 01-APR-2022 | 31-MAR-2022 |

  Scenario: Checks that periodStart is less than or equal to periodEnd (PRESROC)
    When I request a valid new presroc bill run
     And I send the following period dates I am told that periodStart must be less than or equal to periodEnd   
      | presroc | 01-APR-2019 | 31-MAR-2019 |

  Scenario: Checks that periodStart is greater than or equal to the ruleset start date (SROC)
    When I request a valid new sroc bill run
     And I send the following period dates I am told that periodStart is before the ruleset start date
      | sroc    | 01-APR-2020 | 31-MAR-2021 | 2021-04-01 |

  Scenario: Checks that periodStart is greater than or equal to the ruleset start date (PRESROC)
    When I request a valid new presroc bill run
     And I send the following period dates I am told that periodStart is before the ruleset start date    
      | presroc | 01-APR-2013 | 31-MAR-2014 | 2014-04-01 |