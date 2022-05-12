Feature: Create Transaction Validation

  Background: Authenticate
    Given I am the "system" user

  Scenario: Checks for mandatory values (required in all requests) (SROC)
    When I request a valid new sroc bill run
     And I do not send the following values I get the expected response
      | sroc | chargeCategoryCode        |
      | sroc | authorisedDays            |
      | sroc | billableDays              |
      | sroc | winterOnly                |
      | sroc | section130Agreement       |
      | sroc | section127Agreement       |
      | sroc | twoPartTariff             |
      | sroc | compensationCharge        |
      | sroc | waterCompanyCharge        |
      | sroc | supportedSource           |
      | sroc | loss                      |
      | sroc | authorisedVolume          |
      | sroc | credit                    |
      | sroc | periodStart               |
      | sroc | periodEnd                 |
      | sroc | region                    |
      | sroc | customerReference         |
      | sroc | licenceNumber             |
      | sroc | chargePeriod              |
      | sroc | areaCode                  |
      | sroc | lineDescription           |
      | sroc | chargeCategoryDescription |
      | sroc | adjustmentFactor          |
      | sroc | abatementFactor           |
      | sroc | aggregateProportion       |

  Scenario: Checks for mandatory values (required in all requests) (PRESROC)
    When I request a valid new presroc bill run
     And I do not send the following values I get the expected response
      | presroc | authorisedDays       |
      | presroc | billableDays         |
      | presroc | section130Agreement  |
      | presroc | section127Agreement  |
      | presroc | twoPartTariff        |
      | presroc | compensationCharge   |
      | presroc | loss                 |
      | presroc | season               |
      | presroc | volume               |
      | presroc | credit               |
      | presroc | periodStart          |
      | presroc | periodEnd            |
      | presroc | region               |
      | presroc | customerReference    |
      | presroc | licenceNumber        |
      | presroc | chargePeriod         |
      | presroc | areaCode             |
      | presroc | lineDescription      |
      | presroc | source               |
      | presroc | regionalChargingArea |

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
      | sroc | authorisedDays   | 0 | = |
      | sroc | billableDays     | 0 | = |
      | sroc | authorisedVolume | 0 | > |
      | sroc | actualVolume     | 0 | > |

  Scenario: Checks data values are not below the minimum expected (PRESROC)
    When I request a valid new presroc bill run
     And I send the following properties at less than their minimum I am told what they should be
      | presroc | authorisedDays   | 0 | = |
      | presroc | billableDays     | 0 | = |
      | presroc | volume           | 0 | = |

  Scenario: Checks data values are not above the maximum expected (SROC)
    When I request a valid new sroc bill run
     And I send the following properties at more than their maximum I am told what they should be
      | sroc | authorisedDays   | 366 |
      | sroc | billableDays     | 366 |

  Scenario: Checks data values are not above the maximum expected (PRESROC)
    When I request a valid new presroc bill run
     And I send the following properties at more than their maximum I am told what they should be
      | presroc | authorisedDays   | 366 |
      | presroc | billableDays     | 366 |

  Scenario: Check period start and end dates fall in the same financial year (SROC)
    When I request a valid new sroc bill run
     And I send the following period start and end dates I am told what financial year periodEnd must be
      | sroc | 01-APR-2022 | 01-APR-2023 | 2022 |
      | sroc | 31-MAR-2023 | 01-APR-2023 | 2022 |

  Scenario: Check period start and end dates fall in the same financial year (PRESROC)
    When I request a valid new presroc bill run
     And I send the following period start and end dates I am told what financial year periodEnd must be
      | presroc | 01-APR-2018 | 01-APR-2019 | 2018 |
      | presroc | 31-MAR-2019 | 01-APR-2019 | 2018 |

  Scenario: Checks that periodStart is less than or equal to periodEnd (SROC)
    When I request a valid new sroc bill run
     And I send the following period dates I am told that periodStart must be less than or equal to periodEnd
      | sroc | 01-APR-2022 | 31-MAR-2022 |

  Scenario: Checks that periodStart is less than or equal to periodEnd (PRESROC)
    When I request a valid new presroc bill run
     And I send the following period dates I am told that periodStart must be less than or equal to periodEnd
      | presroc | 01-APR-2019 | 31-MAR-2019 |

  Scenario: Checks that periodStart is greater than or equal to the ruleset start date (SROC)
    When I request a valid new sroc bill run
     And I send the following period dates I am told that periodStart is before the ruleset start date
      | sroc | 01-APR-2021 | 31-MAR-2022 | 2022-04-01 |

  Scenario: Checks that periodStart is greater than or equal to the ruleset start date (PRESROC)
    When I request a valid new presroc bill run
     And I send the following period dates I am told that periodStart is before the ruleset start date
      | presroc | 01-APR-2013 | 31-MAR-2014 | 2014-04-01 |

  Scenario: Checks that periodEnd is less than or equal to the ruleset end date
    When I request a valid new presroc bill run
     And I send the following period dates I am told that periodEnd must be before or equal to the ruleset end date
      | presroc | 01-APR-2022 | 31-MAR-2023 | 2022-03-31 |        

# The values in the table relate to what will be sent in the request plus what the CM will report as invalid and what
# it should actually be
# | ruleset | twoPartTariff | compensationCharge | section127Agreement | invalid property | should be |
  Scenario: Checks for invalid combinations (SROC)
    When I request a valid new sroc bill run
     And I send the following invalid combinations I am told what value a property should be
      | sroc | true  | false | false  | section127Agreement | true  |
      | sroc | true  | true  | false  | twoPartTariff       | false |
      | sroc | true  | true  | true   | twoPartTariff       | false |

  Scenario: WaterUndertaker must be true when compensationCharge and waterCompanyCharge are both true
    When I request a valid new sroc bill run
     And I send the following invalid combinations I am told waterUndertaker must be true
      | sroc    | true | true  | waterUndertaker | true |  

# The values in the table relate to what will be sent in the request plus what the CM will report as invalid and what
# it should actually be
# | ruleset | twoPartTariff | compensationCharge | section127Agreement | invalid property | should be |
  Scenario: Checks for invalid combinations (PRESROC)
     When I request a valid new presroc bill run
     And I send the following invalid combinations I am told what value a property should be
      | presroc | true  | false | false  | section127Agreement | true  |
      | presroc | true  | true  | false  | twoPartTariff       | false |
      | presroc | true  | true  | true   | twoPartTariff       | false |

# The values in the table relate to what will be sent in the request for
# | ruleset | twoPartTariff | compensationCharge | section127Agreement |
  Scenario: Allows valid combinations (SROC)
    When I request a valid new sroc bill run
     And I send the following valid combinations it creates the transaction without error
      | sroc | true  | false | true  |
      | sroc | false | false | true  |
      | sroc | false | true  | true  |
      | sroc | false | true  | false |
      | sroc | true  | false | true  |
      | sroc | false | false | false |

# The values in the table relate to what will be sent in the request for
# | ruleset | twoPartTariff | compensationCharge | section127Agreement |
  Scenario: Allows valid combinations (PRESROC)
    When I request a valid new presroc bill run
     And I send the following valid combinations it creates the transaction without error
      | presroc | true  | false | true  |
      | presroc | false | false | true  |
      | presroc | false | true  | false |
      | presroc | false | true  | true  |
      | presroc | true  | false | true  |
      | presroc | false | false | false |

  Scenario: Correctly handles case sensitive data items (SROC)
    When I request a valid new sroc bill run
     And I send the following properties it corrects the case and creates the transaction without error
      | sroc | loss                 | low                                |
      | sroc | loss                 | mediuM                             |
      | sroc | loss                 | hIgh                               |
      | sroc | supportedSourceName  | candover                           |
      | sroc | supportedSourceName  | dee                                |
      | sroc | supportedSourceName  | earl soham - Deben                 |
      | sroc | supportedSourceName  | glen groundwater                   |
      | sroc | supportedSourceName  | great east anglian groundwater     |
      | sroc | supportedSourceName  | great eAst anglian surface water   |
      | sroc | supportedSourceName  | kielder                            |
      | sroc | supportedSourceName  | lodes granta groundwater           |
      | sroc | supportedSourceName  | lower yorkshire derwent            |
      | sroc | supportedSourceName  | medway - allington                 |
      | sroc | supportedSourceName  | nene - northampton                 |
      | sroc | supportedSourceName  | nene - water newton                |
      | sroc | supportedSourceName  | ouse - eaton socon                 |
      | sroc | supportedSourceName  | ouse - hermitage                   |
      | sroc | supportedSourceName  | ouse - oFford                      |
      | sroc | supportedSourceName  | rhee groundwateR                   |
      | sroc | supportedSourceName  | severn                             |
      | sroc | supportedSourceName  | thames                             |
      | sroc | supportedSourceName  | thet and little ouse surface water |
      | sroc | supportedSourceName  | waveney groundwater                |
      | sroc | supportedSourceName  | waveney surface water              |
      | sroc | supportedSourceName  | welland - tinwell sluices          |
      | sroc | supportedSourceName  | witham and ancholme                |
      | sroc | supportedSourceName  | wye                                |
      | sroc | regionalChargingArea | anglian                            |
      | sroc | regionalChargingArea | midlands                           |
      | sroc | regionalChargingArea | northumbria                        |
      | sroc | regionalChargingArea | north west                         |
      | sroc | regionalChargingArea | southern                           |
      | sroc | regionalChargingArea | south west (incl wessex)           |
      | sroc | regionalChargingArea | devon and cornwall (south west)    |
      | sroc | regionalChargingArea | north and south wessex             |
      | sroc | regionalChargingArea | thames                             |
      | sroc | regionalChargingArea | yorkshire                          |
      | sroc | regionalChargingArea | dee                                |
      | sroc | regionalChargingArea | wye                                |
      | sroc | regionalChargingArea | wales                              |

 Scenario: Correctly handles case sensitive data items (PRESROC)
    When I request a valid new presroc bill run
     And I send the following properties it corrects the case and creates the transaction without error
      | presroc | loss                 | low                             |
      | presroc | loss                 | mediuM                          |
      | presroc | loss                 | hIgh                            |
      | presroc | loss                 | very Low                        |
      | presroc | season               | summer                          |
      | presroc | season               | winter                          |
      | presroc | season               | all year                        |
      | presroc | source               | supported                       |
      | presroc | source               | unsupported                     |
      | presroc | source               | kielder                         |
      | presroc | source               | tidal                           |
      | presroc | eiucSource           | kielder                         |
      | presroc | eiucSource           | tidal                           |
      | presroc | regionalChargingArea | anglian                         |
      | presroc | regionalChargingArea | midlands                        |
      | presroc | regionalChargingArea | northumbria                     |
      | presroc | regionalChargingArea | north west                      |
      | presroc | regionalChargingArea | southern                        |
      | presroc | regionalChargingArea | south west (incl wessex)        |
      | presroc | regionalChargingArea | devon and cornwall (south west) |
      | presroc | regionalChargingArea | north and south wessex          |
      | presroc | regionalChargingArea | thames                          |
      | presroc | regionalChargingArea | yorkshire                       |
      | presroc | regionalChargingArea | dee                             |
      | presroc | regionalChargingArea | wye                             |
      | presroc | regionalChargingArea | wales                           |

 Scenario: Checks that supportedSourceName is set correctly according to how supportedSource is set
    When I request a valid new sroc bill run
     And I send the following supported source values I get the expected response
      | sroc | false | Dee | 422 |
      | sroc | true  |     | 422 |
      | sroc | true  | Dee | 200 |

  Scenario: Checks data strings are not above the maximum expected (SROC)
    When I request a valid new sroc bill run
     And I send the following properties with more than their maximum chars I am told what they should be
      | sroc | customerReference         | 12  |
      | sroc | licenceNumber             | 150 |
      | sroc | chargeCategoryDescription | 150 |
      | sroc | lineDescription           | 240 |
      | sroc | chargePeriod              | 150 |

  Scenario: Checks data strings are not above the maximum expected (PRESROC)
    When I request a valid new presroc bill run
     And I send the following properties with more than their maximum chars I am told what they should be
      | presroc | customerReference | 12  |
      | presroc | licenceNumber     | 150 |
      | presroc | lineDescription   | 240 |
      | presroc | chargePeriod      | 150 |

   Scenario: Checks that areaCode rejects unexpected values (SROC)
    When I request a valid new sroc bill run
     And I send invalid areaCode I am told what it should be
      | sroc | areaCode | 1 |

   Scenario: Checks that areaCode rejects unexpected values (PRESROC)
    When I request a valid new presroc bill run
     And I send invalid areaCode I am told what it should be
      | presroc | areaCode | 1 |

  Scenario: Checks that areaCode allows expected values (SROC)
    When I request a valid new sroc bill run
     And I send the following values it creates the transaction without error
      | sroc | areaCode | ArCA    |
      | sroc | areaCode | AREA    |
      | sroc | areaCode | ARNA    |
      | sroc | areaCode | CASc    |
      | sroc | areaCode | MIDLS   |
      | sroc | areaCode | MIDLT   |
      | sroc | areaCode | MIDUS   |
      | sroc | areaCode | MIDUT   |
      | sroc | areaCode | AACOR   |
      | sroc | areaCode | AaDEV   |
      | sroc | areaCode | AANWX   |
      | sroc | areaCode | AASWX   |
      | sroc | areaCode | NWCEN   |
      | sroc | areaCode | NWNTH   |
      | sroc | areaCode | NWSTH   |
      | sroc | areaCode | HAAR    |
      | sroc | areaCode | KAEA    |
      | sroc | areaCode | SAAR    |
      | sroc | areaCode | AGY2N   |
      | sroc | areaCode | AGY2S   |
      | sroc | areaCode | AGY3    |
      | sroc | areaCode | AGY3N   |
      | sroc | areaCode | AGY3S   |
      | sroc | areaCode | AgY4N   |
      | sroc | areaCode | AGY4S   |
      | sroc | areaCode | N       |
      | sroc | areaCode | SE      |
      | sroc | areaCode | SE1     |
      | sroc | areaCode | SE2     |
      | sroc | areaCode | SW      |
      | sroc | areaCode | ABNRTH  |
      | sroc | areaCode | DALES   |
      | sroc | areaCode | NAREA   |
      | sroc | areaCode | RIDIN   |
      | sroc | areaCode | DEFAULT |
      | sroc | areaCode | MULTI   |

  Scenario: Checks that areaCode allows expected values (PRESROC)
    When I request a valid new presroc bill run
     And I send the following values it creates the transaction without error
      | presroc | areaCode | ArCA    |
      | presroc | areaCode | AREA    |
      | presroc | areaCode | ARNA    |
      | presroc | areaCode | CASc    |
      | presroc | areaCode | MIDLS   |
      | presroc | areaCode | MIDLT   |
      | presroc | areaCode | MIDUS   |
      | presroc | areaCode | MIDUT   |
      | presroc | areaCode | AACOR   |
      | presroc | areaCode | AaDEV   |
      | presroc | areaCode | AANWX   |
      | presroc | areaCode | AASWX   |
      | presroc | areaCode | NWCEN   |
      | presroc | areaCode | NWNTH   |
      | presroc | areaCode | NWSTH   |
      | presroc | areaCode | HAAR    |
      | presroc | areaCode | KAEA    |
      | presroc | areaCode | SAAR    |
      | presroc | areaCode | AGY2N   |
      | presroc | areaCode | AGY2S   |
      | presroc | areaCode | AGY3    |
      | presroc | areaCode | AGY3N   |
      | presroc | areaCode | AGY3S   |
      | presroc | areaCode | AgY4N   |
      | presroc | areaCode | AGY4S   |
      | presroc | areaCode | N       |
      | presroc | areaCode | SE      |
      | presroc | areaCode | SE1     |
      | presroc | areaCode | SE2     |
      | presroc | areaCode | SW      |
      | presroc | areaCode | ABNRTH  |
      | presroc | areaCode | DALES   |
      | presroc | areaCode | NAREA   |
      | presroc | areaCode | RIDIN   |
      | presroc | areaCode | DEFAULT |
      | presroc | areaCode | MULTI   |

  Scenario: Checks that region rejects unexpected values (SROC)
    When I request a valid new sroc bill run
     And I send the following invalid combinations I am told Billrun and transaction regions do not match
      | sroc | A | region | Y |
      | sroc | B | region | W |
      | sroc | E | region | T |
      | sroc | N | region | S |
      | sroc | S | region | N |
      | sroc | T | region | E |
      | sroc | W | region | B |
      | sroc | Y | region | A |

  Scenario: Checks that region rejects unexpected values (PRESROC)
    When I request a valid new presroc bill run
     And I send the following invalid combinations I am told Billrun and transaction regions do not match
      | presroc | A | region | Y |
      | presroc | B | region | W |
      | presroc | E | region | T |
      | presroc | N | region | S |
      | presroc | S | region | N |
      | presroc | T | region | E |
      | presroc | W | region | B |
      | presroc | Y | region | A |

   Scenario: Checks that region allows expected values (SROC)
    When I request a valid new sroc bill run
     And I send the following valid Billrun and transaction combinations it creates the transaction without error
      | sroc | A | region | A |
      | sroc | B | region | B |
      | sroc | E | region | E |
      | sroc | N | region | N |
      | sroc | S | region | S |
      | sroc | T | region | T |
      | sroc | W | region | W |
      | sroc | Y | region | Y |

  Scenario: Checks that region allows expected values (PRESROC)
    When I request a valid new presroc bill run
     And I send the following valid Billrun and transaction combinations it creates the transaction without error
      | presroc | A | region | A |
      | presroc | B | region | B |
      | presroc | E | region | E |
      | presroc | N | region | N |
      | presroc | S | region | S |
      | presroc | T | region | T |
      | presroc | W | region | W |
      | presroc | Y | region | Y |

  Scenario: Checks special characters are rejected (SROC)
    When I request a valid new sroc bill run
     And I send the following properties with special characters I am told the request cannot be accepted
      | sroc | customerReference         | test“ |
      | sroc | licenceNumber             | test“ |
      | sroc | areaCode                  | test“ |
      | sroc | chargeCategoryDescription | test“ |
      | sroc | lineDescription           | test“ |
      | sroc | chargePeriod              | test“ |
      | sroc | customerReference         | test” |
      | sroc | licenceNumber             | test” |
      | sroc | areaCode                  | test” |
      | sroc | chargeCategoryDescription | test” |
      | sroc | lineDescription           | test” |
      | sroc | chargePeriod              | test” |
      | sroc | customerReference         | test? |
      | sroc | licenceNumber             | test? |
      | sroc | areaCode                  | test? |
      | sroc | chargeCategoryDescription | test? |
      | sroc | lineDescription           | test? |
      | sroc | chargePeriod              | test? |
      | sroc | customerReference         | test^ |
      | sroc | licenceNumber             | test^ |
      | sroc | areaCode                  | test^ |
      | sroc | chargeCategoryDescription | test^ |
      | sroc | lineDescription           | test^ |
      | sroc | chargePeriod              | test^ |
      | sroc | customerReference         | test£ |
      | sroc | licenceNumber             | test£ |
      | sroc | areaCode                  | test£ |
      | sroc | chargeCategoryDescription | test£ |
      | sroc | lineDescription           | test£ |
      | sroc | chargePeriod              | test£ |
      | sroc | customerReference         | test≥ |
      | sroc | licenceNumber             | test≥ |
      | sroc | areaCode                  | test≥ |
      | sroc | chargeCategoryDescription | test≥ |
      | sroc | lineDescription           | test≥ |
      | sroc | chargePeriod              | test≥ |
      | sroc | customerReference         | test≤ |
      | sroc | licenceNumber             | test≤ |
      | sroc | areaCode                  | test≤ |
      | sroc | chargeCategoryDescription | test≤ |
      | sroc | lineDescription           | test≤ |
      | sroc | chargePeriod              | test≤ |
      | sroc | customerReference         | test— |
      | sroc | licenceNumber             | test— |
      | sroc | areaCode                  | test— |
      | sroc | chargeCategoryDescription | test— |
      | sroc | lineDescription           | test— |
      | sroc | chargePeriod              | test— |

 Scenario: Checks special characters are rejected (PRESROC)
    When I request a valid new presroc bill run
     And I send the following properties with special characters I am told the request cannot be accepted
      | presroc | customerReference         | test“ |
      | presroc | licenceNumber             | test“ |
      | presroc | areaCode                  | test“ |
      | presroc | chargeCategoryDescription | test“ |
      | presroc | lineDescription           | test“ |
      | presroc | chargePeriod              | test“ |
      | presroc | customerReference         | test” |
      | presroc | licenceNumber             | test” |
      | presroc | areaCode                  | test” |
      | presroc | chargeCategoryDescription | test” |
      | presroc | lineDescription           | test” |
      | presroc | chargePeriod              | test” |
      | presroc | customerReference         | test? |
      | presroc | licenceNumber             | test? |
      | presroc | areaCode                  | test? |
      | presroc | chargeCategoryDescription | test? |
      | presroc | lineDescription           | test? |
      | presroc | chargePeriod              | test? |
      | presroc | customerReference         | test^ |
      | presroc | licenceNumber             | test^ |
      | presroc | areaCode                  | test^ |
      | presroc | chargeCategoryDescription | test^ |
      | presroc | lineDescription           | test^ |
      | presroc | chargePeriod              | test^ |
      | presroc | customerReference         | test£ |
      | presroc | licenceNumber             | test£ |
      | presroc | areaCode                  | test£ |
      | presroc | chargeCategoryDescription | test£ |
      | presroc | lineDescription           | test£ |
      | presroc | chargePeriod              | test£ |
      | presroc | customerReference         | test≥ |
      | presroc | licenceNumber             | test≥ |
      | presroc | areaCode                  | test≥ |
      | presroc | chargeCategoryDescription | test≥ |
      | presroc | lineDescription           | test≥ |
      | presroc | chargePeriod              | test≥ |
      | presroc | customerReference         | test≤ |
      | presroc | licenceNumber             | test≤ |
      | presroc | areaCode                  | test≤ |
      | presroc | chargeCategoryDescription | test≤ |
      | presroc | lineDescription           | test≤ |
      | presroc | chargePeriod              | test≤ |
      | presroc | customerReference         | test— |
      | presroc | licenceNumber             | test— |
      | presroc | areaCode                  | test— |
      | presroc | chargeCategoryDescription | test— |
      | presroc | lineDescription           | test— |
      | presroc | chargePeriod              | test— |
