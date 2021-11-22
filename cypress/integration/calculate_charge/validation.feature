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
