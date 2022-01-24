Feature: Customer Changes Validation

  Background: Authenticate
    Given I am the "system" user

  Scenario: Checks for mandatory values (required in all requests)
    When I do not send the following values I am told they are required
      | region            |
      | customerReference |
      | customerName      |
      | addressLine1      |

  Scenario: Checks that values are optional
    When I do not send the following values it confirms the change without error
      | addressLine2 |
      | addressLine3 |
      | addressLine4 |
      | addressLine5 |
      | addressLine6 |
      | postcode     |

  Scenario: Checks that values are not too long
    When I send values that are too long I am told what their maximum length is
      | customerReference | 12  |
      | customerName      | 360 |
      | addressLine1      | 240 |
      | addressLine2      | 240 |
      | addressLine3      | 240 |
      | addressLine4      | 240 |
      | addressLine5      | 60  |
      | addressLine6      | 60  |
      | postcode          | 60  |

  Scenario: Checks that values at their maximum length are accepted
    When I send values that are their maximum length it confirms the change without error
      | customerReference | 12  |
      | customerName      | 360 |
      | addressLine1      | 240 |
      | addressLine2      | 240 |
      | addressLine3      | 240 |
      | addressLine4      | 240 |
      | addressLine5      | 60  |
      | addressLine6      | 60  |
      | postcode          | 60  |
