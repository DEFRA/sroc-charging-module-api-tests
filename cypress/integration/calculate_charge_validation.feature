Feature: Calculate Charge Validation
  #CMEA-194

  Background: Authenticate
    Given I am the "system" user

  #AC8
  Scenario Outline: Data items must allow numbers with decimal places
    When I calculate a valid <ruleset> charge with <dataItem> as <value>
    Then a charge is calculated

    Examples:
      | ruleset | dataItem            | value       |
      | sroc    | abatementFactor     | 1.242       |
      | sroc    | aggregateProportion | 0.001       |
      | sroc    | volume              | 0.00048     |
      | sroc    | actualVolume        | 14254.11249 |

  #AC9
  Scenario Outline: authorisedDays and billableDays must be integers between 0 and 366
    When I calculate a valid <ruleset> charge with <dataItem> as <value>
    Then a charge is calculated

    Examples:
      | ruleset | dataItem       | value |
      | sroc    | authorisedDays | 366   |
      | sroc    | authorisedDays | 0     |
      | sroc    | authorisedDays | 152   |
      | sroc    | billableDays   | 366   |
      | sroc    | billableDays   | 0     |
      | sroc    | billableDays   | 75    |
      | presroc | authorisedDays | 366   |
      | presroc | authorisedDays | 0     |
      | presroc | authorisedDays | 152   |
      | presroc | billableDays   | 366   |
      | presroc | billableDays   | 0     |
      | presroc | billableDays   | 75    |

  Scenario Outline: authorisedDays and billableDays must be less than or equal to 366 and greater than or equal to 0
    When I calculate an invalid <ruleset> charge with <dataItem> as <value>
    Then I am told that the <dataItem> number must be <value1> than or equal to <value2>

    Examples:
      | ruleset | dataItem       | value | value1  | value2 |
      | sroc    | authorisedDays | 367   | less    | 366    |
      | sroc    | authorisedDays | -1    | greater | 0      |
      | sroc    | billableDays   | 367   | less    | 366    |
      | sroc    | billableDays   | -1    | greater | 0      |
      | presroc | authorisedDays | 367   | less    | 366    |
      | presroc | authorisedDays | -1    | greater | 0      |
      | presroc | billableDays   | 367   | less    | 366    |
      | presroc | billableDays   | -1    | greater | 0      |

  Scenario Outline: authorisedDays and billableDays must be an integer
    When I calculate an invalid <ruleset> charge with <dataItem> as <value>
    Then I am told the <dataItem> must be an <value1>

    Examples:
      | ruleset | dataItem       | value | value1  |
      | sroc    | authorisedDays | 1.1   | integer |
      | sroc    | authorisedDays | 1.1   | integer |
      | sroc    | billableDays   | 1.1   | integer |
      | sroc    | billableDays   | 1.1   | integer |
      | presroc | authorisedDays | 1.1   | integer |
      | presroc | authorisedDays | 1.1   | integer |
      | presroc | billableDays   | 1.1   | integer |
      | presroc | billableDays   | 1.1   | integer |

  #AC10
  Scenario Outline: authorisedVolume must greater than 0
    When I calculate an invalid <ruleset> charge with <dataItem> as <value>
    Then I am told that the <dataItem> number must be <value1> than <value2>

    Examples:
      | ruleset | dataItem | value | value1  | value2 |
      | sroc    | volume   | 0     | greater | 0      |

  #AC12/13/14
  Scenario Outline: CM rejects invalid data item combinations
    When I calculate an invalid <ruleset> charge with <dataItem1> as <value> and <dataItem> as <value1>
    Then I am told the <dataItem> must be <value>

    Examples:
      | ruleset | dataItem1          | value | dataItem            | value1 |
      | sroc    | twoPartTariff      | true  | section127Agreement | false  |
      | sroc    | compensationCharge | true  | section127Agreement | true   |
      | sroc    | twoPartTariff      | true  | compensationCharge  | true   |

  #AC15
  Scenario Outline: Case sensitive data items are handled correctly
    When I calculate a valid <ruleset> charge with <dataItem> as '<value>'
    Then a charge is calculated

    Examples:
      | ruleset | dataItem             | value                              |
      | sroc    | loss                 | low                                |
      | sroc    | loss                 | mediuM                             |
      | sroc    | loss                 | hIgh                               |
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
      | sroc    | supportedSourceName  | nene – northampton                 |
      | sroc    | supportedSourceName  | nene – water newton                |
      | sroc    | supportedSourceName  | ouse – eaton socon                 |
      | sroc    | supportedSourceName  | ouse – hermitage                   |
      | sroc    | supportedSourceName  | ouse - oFford                      |
      | sroc    | supportedSourceName  | rhee groundwateR                   |
      | sroc    | supportedSourceName  | severn                             |
      | sroc    | supportedSourceName  | thames                             |
      | sroc    | supportedSourceName  | thet and little ouse surface water |
      | sroc    | supportedSourceName  | waveney groundwater                |
      | sroc    | supportedSourceName  | waveney surface water              |
      | sroc    | supportedSourceName  | welland – tinwell sluices          |
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

  #AC17
  # TODO: Populate with correct Then step
  @ignore
  Scenario Outline: Supported Source Name is handled if Supported Source is false
    When I calculate a valid <ruleset> charge with <dataItem1> as <value> and <dataItem> as <value1>
    #Then {placeholder for assertion according to error messages}

    Examples:
      | ruleset | dataItem1       | value | dataItem            | value1 |
      | sroc    | supportedSource | false | supportedSourceName | Dee    |
      | sroc    | supportedSource | true  | supportedSourceName | ' '    |

  # TODO: Populate with correct Then step
  @ignore
  Scenario Outline: Supported Source Name must be present if Supported Source is true
    When I calculate an invalid <ruleset> charge with <dataItem1> as <value> and <dataItem> as <value1>
    #Then {placeholder for assertion according to error messages}

    Examples:
      | ruleset | dataItem1       | value | dataItem            | value1 |
      | sroc    | supportedSource | false | supportedSourceName | Dee    |
      | sroc    | supportedSource | true  | supportedSourceName | ' '    |
