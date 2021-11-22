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
      | sroc     | chargeCategoryCode  |
      | sroc     | periodStart         |
      | sroc     | authorisedDays      |
      | sroc     | billableDays        |
      | sroc     | winterOnly          |
      | sroc     | section130Agreement |
      | sroc     | section127Agreement |
      | sroc     | twoPartTariff       |
      | sroc     | compensationCharge  |
      | sroc     | waterCompanyCharge  |
      | sroc     | supportedSource     |
      | sroc     | loss                |
      | sroc     | authorisedVolume    |
      | sroc     | credit              |
      | sroc     | ruleset             |
      | sroc     | periodStart         |
      | sroc     | periodEnd           |
      | presroc  | periodEnd           |

  Scenario: Checks for mandatory values when compensationCharge is true (SROC)
    When I send a sroc request where compensationCharge is true
    Then If I do not send the following values I get the expected response
      | regionalChargingArea |
      | waterUndertaker      |

  Scenario: Checks for mandatory values when compensationCharge is true (PRESROC)
    When I send a presroc request where compensationCharge is true
    Then If I do not send the following values I get the expected response
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

  # TODO: This scenario is checking that the CM defaults certain fields when they are not included in the request.
  # However, it is doing this by checking the values of certain fields in the CM response. The problem is the fields
  # listed are returned from the rules service, not the CM. So, at this time we're not sure how the scenario needs to be
  # re-configured to confirm the default values are applied.
  @ignore
  Scenario: Sets default values
    When I do not send the following values the CM sets the correct default
      | sroc    | abatementAdjustment | abatementFactor     | 1 |
      | sroc    | aggregateProportion | aggregateProportion | 1 |
