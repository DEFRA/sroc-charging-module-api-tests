Feature: Calculate Charge Validation

  Background: Authenticate
    Given I am the "system" user

  Scenario: Ruleset must be a known value
    When I use the following ruleset values I get the expected response
      | sroc    | 200 |
      | presroc | 200 |
      | cors    | 422 |

  Scenario: Checks for mandatory values (required in all requests)
    When I do not send the following values I get the expected response
      | sroc    | chargeCategoryCode  |
      | sroc    | periodStart         |
      | sroc    | authorisedDays      |
      | sroc    | billableDays        |
      | sroc    | winterOnly          |
      | sroc    | section130Agreement |
      | sroc    | section127Agreement |
      | sroc    | twoPartTariff       |
      | sroc    | compensationCharge  |
      | sroc    | waterCompanyCharge  |
      | sroc    | supportedSource     |
      | sroc    | loss                |
      | sroc    | authorisedVolume    |
      | sroc    | credit              |
      | sroc    | ruleset             |
      | sroc    | periodStart         |
      | sroc    | periodEnd           |
      | sroc    | adjustmentFactor    |
      | presroc | periodEnd           |

  Scenario: Checks for mandatory values when compensationCharge is true (SROC)
    When I send a sroc request where compensationCharge is true
    Then If I do not send the following values I get the expected response
      | regionalChargingArea |
      | waterUndertaker      |

  Scenario: Checks for mandatory values when compensationCharge is true (PRESROC)
    When I send a presroc request where compensationCharge is true
    Then If I do not send the following values I get the expected response
      | regionalChargingArea |
      | eiucSource           |
      | waterUndertaker      |

  Scenario: Checks for mandatory values when twoPartTariff is true
    When I send a sroc request where twoPartTariff is true
    Then If I do not send the following values I get the expected response
      | actualVolume |

  Scenario: Checks for mandatory values when supportedSource is true
    When I send a sroc request where supportedSource is true
    Then If I do not send the following values I get the expected response
      | supportedSourceName |

  Scenario: Sets default values
    When I do not send the following values the CM sets the correct default
      | sroc    | abatementFactor     | 1.0 |
      | sroc    | aggregateProportion | 1.0 |
      | presroc | section126Factor    | 1.0 |

  Scenario: Checks data types of values
    When I send the following properties with the wrong data types I am told what they should be
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
      | presroc | section130Agreement | boolean |
      | presroc | section127Agreement | boolean |
      | presroc | twoPartTariff       | boolean |
      | presroc | compensationCharge  | boolean |
      | presroc | credit              | boolean |
      | presroc | authorisedDays      | number  |
      | presroc | billableDays        | number  |
      | presroc | section126Factor    | number  |
      | presroc | volume              | number  |

  Scenario: Checks integer data properties are not sent as decimals
    When I send the following properties as decimals I am told they should be integers
      | sroc    | authorisedDays |
      | sroc    | billableDays   |
      | presroc | authorisedDays |
      | presroc | billableDays   |

  Scenario: Allows decimal values in number data properties
    When I send the following properties as decimals calculates the charge without error
      | sroc    | abatementFactor     | number |
      | sroc    | aggregateProportion | number |
      | sroc    | authorisedVolume    | number |
      | sroc    | actualVolume        | number |
      | presroc | section126Factor    | number |
      | presroc | volume              | number |

  Scenario: Checks data values are not below the minimum expected
    When I send the following properties at less than their minimum I am told what they should be
      | sroc    | authorisedDays   | 0 | = |
      | sroc    | billableDays     | 0 | = |
      | sroc    | authorisedVolume | 0 | > |
      | sroc    | actualVolume     | 0 | > |
      | presroc | authorisedDays   | 0 | = |
      | presroc | billableDays     | 0 | = |
      | presroc | volume           | 0 | = |

  Scenario: Checks data values are not above the maximum expected
    When I send the following properties at more than their maximum I am told what they should be
      | sroc    | authorisedDays | 366 |
      | sroc    | billableDays   | 366 |
      | presroc | authorisedDays | 366 |
      | presroc | billableDays   | 366 |

  # section126Factor only applies to presroc bill runs and has a limit on the number of decimal places. The rules
  # service has the limitation and errors if a value with too many decimal places is sent through.
  Scenario: Checks presroc section126Factor does not accept numbers with more than 3 decimal places
    When I send a section126Factor value with more than 3 decimal places I am told there are too many

  Scenario: Checks period start and end dates are valid dates
    When I send the following period start and end dates I am told they must have a valid date format
      | sroc    | periodStart | -APR-2021   |
      | sroc    | periodStart | 01--2021    |
      | sroc    | periodStart | 01-APR-20-- |
      | sroc    | periodEnd   | -03-2022    |
      | sroc    | periodEnd   | 31--2022    |
      | sroc    | periodEnd   | 31-MAR-20-- |
      | presroc | periodStart | -APR-2020   |
      | presroc | periodStart | 01--2020    |
      | presroc | periodStart | 01-APR-20-- |
      | presroc | periodEnd   | -03-2021    |
      | presroc | periodEnd   | 31--2021    |
      | presroc | periodEnd   | 31-MAR-20-- |

  Scenario: Allows period start and end dates in various formats
    When I send the following period start and end dates it calculates the charge without error
      | sroc    | periodStart | 01-APR-2021 |
      | sroc    | periodStart | 01-04-2021  |
      | sroc    | periodEnd   | 31-MAR-2022 |
      | sroc    | periodEnd   | 31-03-2022  |
      | presroc | periodStart | 01-APR-2018 |
      | presroc | periodStart | 01-04-2018  |
      | presroc | periodEnd   | 31-MAR-2019 |
      | presroc | periodEnd   | 31-03-2019  |

  Scenario: Check period start and end dates fall in the same financial year
    When I send the following period start and end dates I am told what financial year periodEnd must be
      | sroc    | 01-APR-2022 | 01-APR-2023 | 2022 |
      | sroc    | 31-MAR-2023 | 01-APR-2023 | 2022 |
      | presroc | 01-APR-2020 | 01-APR-2021 | 2020 |
      | presroc | 31-MAR-2021 | 01-APR-2021 | 2020 |

  Scenario: Checks that periodStart is less than or equal to periodEnd
    When I send the following period dates I am told that periodStart must be less than or equal to periodEnd
      | sroc    | 01-APR-2022 | 31-MAR-2022 |
      | presroc | 01-APR-2019 | 31-MAR-2019 |

  Scenario: Checks that periodStart is greater than or equal to the ruleset start date
    When I send the following period dates I am told that periodStart is before the ruleset start date
      | sroc    | 01-APR-2020 | 31-MAR-2021 | 2021-04-01 |
      | presroc | 01-APR-2013 | 31-MAR-2014 | 2014-04-01 |

  # The values in the table relate to what will be sent in the request plus what the CM will report as invalid and what
  # it should actually be
  # | ruleset | twoPartTariff | compensationCharge | section127Agreement | invalid property | should be |
  Scenario: Checks for invalid combinations
    When I send the following invalid combinations I am told what value a property should be
      | sroc    | true  | false | false | section127Agreement | true  |
      | sroc    | true  | true  | false | twoPartTariff       | false |
      | sroc    | true  | true  | true  | twoPartTariff       | false |
      | presroc | true  | false | false | section127Agreement | true  |
      | presroc | true  | true  | false | twoPartTariff       | false |
      | presroc | true  | true  | true  | twoPartTariff       | false |

  # The values in the table relate to what will be sent in the request for
  # | ruleset | twoPartTariff | compensationCharge | section127Agreement |
  Scenario: Allows valid combinations
    When I send the following valid combinations it calculates the charge without error
      | sroc    | true  | false | true  |
      | sroc    | false | false | true  |
      | sroc    | false | true  | true  |
      | sroc    | false | true  | false |
      | sroc    | true  | false | true  |
      | sroc    | false | false | false |
      | presroc | true  | false | true  |
      | presroc | false | false | true  |
      | presroc | false | true  | true  |
      | presroc | false | true  | false |
      | presroc | true  | false | true  |
      | presroc | false | false | false |

  Scenario: Correctly handles case sensitive data items
    When I send the following properties it corrects the case and calculates the charge without error
      | sroc    | loss                 | low                                |
      | sroc    | loss                 | mediuM                             |
      | sroc    | loss                 | hIgh                               |
      | presroc | loss                 | very low                           |
      | presroc | loss                 | low                                |
      | presroc | loss                 | mediuM                             |
      | presroc | loss                 | hIgh                               |
      | presroc | season               | winter                             |
      | presroc | season               | summer                             |
      | presroc | season               | all year                           |
      | sroc    | supportedSourceName  | candover                           |
      | sroc    | supportedSourceName  | dee                                |
      | sroc    | supportedSourceName  | earl soham - Deben                 |
      | sroc    | supportedSourceName  | glen groundwater                   |
      | sroc    | supportedSourceName  | great east anglian groundwater     |
      | sroc    | supportedSourceName  | great eAst anglian surface water   |
      | sroc    | supportedSourceName  | kielder                            |
      | sroc    | supportedSourceName  | lodes granta groundwater           |
      | sroc    | supportedSourceName  | lower yorkshire derwent            |
      | sroc    | supportedSourceName  | medway - allington                 |
      | sroc    | supportedSourceName  | nene - northampton                 |
      | sroc    | supportedSourceName  | nene - water newton                |
      | sroc    | supportedSourceName  | ouse - eaton socon                 |
      | sroc    | supportedSourceName  | ouse - hermitage                   |
      | sroc    | supportedSourceName  | ouse - oFford                      |
      | sroc    | supportedSourceName  | rhee groundwateR                   |
      | sroc    | supportedSourceName  | severn                             |
      | sroc    | supportedSourceName  | thames                             |
      | sroc    | supportedSourceName  | thet and little ouse surface water |
      | sroc    | supportedSourceName  | waveney groundwater                |
      | sroc    | supportedSourceName  | waveney surface water              |
      | sroc    | supportedSourceName  | welland - tinwell sluices          |
      | sroc    | supportedSourceName  | witham and ancholme                |
      | sroc    | supportedSourceName  | wye                                |
      | sroc    | regionalChargingArea | anglian                            |
      | sroc    | regionalChargingArea | midlands                           |
      | sroc    | regionalChargingArea | northumbria                        |
      | sroc    | regionalChargingArea | north west                         |
      | sroc    | regionalChargingArea | southern                           |
      | sroc    | regionalChargingArea | south west (incl wessex)           |
      | sroc    | regionalChargingArea | devon and cornwall (south west)    |
      | sroc    | regionalChargingArea | north and south wessex             |
      | sroc    | regionalChargingArea | thames                             |
      | sroc    | regionalChargingArea | yorkshire                          |
      | sroc    | regionalChargingArea | dee                                |
      | sroc    | regionalChargingArea | wye                                |
      | sroc    | regionalChargingArea | wales                              |
      | presroc | source               | supported                          |
      | presroc | source               | unsupported                        |
      | presroc | source               | kielder                            |
      | presroc | source               | tidal                              |
      | presroc | eiucSource           | kielder                            |
      | presroc | eiucSource           | tidal                              |
      | presroc | regionalChargingArea | anglian                            |
      | presroc | regionalChargingArea | midlands                           |
      | presroc | regionalChargingArea | northumbria                        |
      | presroc | regionalChargingArea | north west                         |
      | presroc | regionalChargingArea | southern                           |
      | presroc | regionalChargingArea | south west (incl wessex)           |
      | presroc | regionalChargingArea | devon and cornwall (south west)    |
      | presroc | regionalChargingArea | north and south wessex             |
      | presroc | regionalChargingArea | thames                             |
      | presroc | regionalChargingArea | yorkshire                          |
      | presroc | regionalChargingArea | dee                                |
      | presroc | regionalChargingArea | wye                                |
      | presroc | regionalChargingArea | wales                              |

  Scenario: Checks that supportedSourceName is set correctly according to how supportedSource is set
    When I send the following supported source values I get the expected response
      | sroc | false | Dee | 422 |
      | sroc | true  |     | 422 |
      | sroc | true  | Dee | 200 |

  # In PostgreSQL an integer is any value between -2147483648 to +2147483647. We had issues in the early days with
  # results that were greater than this value (though it applied to bill runs overall). So, to be on the safe side we
  # check that the API can handle returning charge values greater than this without error
  # TODO: Can't seem to generate a value greater than 9700 for SROC
  Scenario: Checks the CM can handle big integers
    When I send a request that results in a big integer it calculates the charge without error
      | sroc    |
      | presroc |

  Scenario: Rejects any requests that contains invalid characters
    When I send the following invalid characters it rejects
      | £ | Pound sign                  |
      | ? | Question mark               |
      | — | Em dash                     |
      | ≤ | Less-Than or Equal To       |
      | ≥ | Greater-Than or Equal To    |
      | “ | Left Double Quotation Mark  |
      | ” | Right Double Quotation Mark |
