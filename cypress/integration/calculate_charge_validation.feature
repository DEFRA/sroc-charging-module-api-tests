Feature: Calculate Charge Validation
  #CMEA-194

  Background: Authenticate
    Given I am the "system" user

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
