Feature: Calculate Charge Validation
  #CMEA-194

  Background: Authenticate
    Given I am the "system" user

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
