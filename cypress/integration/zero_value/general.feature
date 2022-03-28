Feature: Zero Value

  Background: Authenticate
    Given I am the "system" user 

#Negative scenarios covered as part of the deminimis tests 

  Scenario: Invoice net total of £0 is zero value invoice (SROC)
    When I request a valid new sroc bill run
     And I add a successful sroc zeroValue transaction for customer CM00000001
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net | customerRef |
      | false | true  | 0    | 0   | 0   | CM00000001  |  
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Transaction added to invoice to make net total of £0 is zero value (SROC)
    When I request a valid new sroc bill run
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 11.00       |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
     And the invoice summary includes the expected items
     #| demin | zeroV | cred | deb  | net  | customerRef |
      | false | false | 0    | 1100 | 1100 | CM00000001  |
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM02 | 9.00        |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM03 | 2.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb  | net | customerRef |
      | false | true  | 1100 | 1100 | 0   | CM00000001  |  
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Transaction removed from invoice to make net total £0 is zero value (SROC)
    When I request a valid new sroc bill run
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 2.00        |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM02 | 150.00      |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM03 | 2.00        |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM04 | 2.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to delete the licence LIC/NUM/CM02 for CM00000001
     And bill run status is updated to "generated"
     And I request to delete the licence LIC/NUM/CM03 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net | customerRef |
      | false | true  | 200  | 200 | 0   | CM00000001  |  
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |    

  Scenario: Invoice net total of £0 is zero value invoice (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful presroc zeroValue transaction for customer CM00000001
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net | customerRef |
      | false | true  | 0    | 0   | 0   | CM00000001  |  
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Transaction added to invoice to make net total of £0 is zero value (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 11.00       |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
     And the invoice summary includes the expected items
     #| demin | zeroV | cred | deb  | net  | customerRef |
      | false | false | 0    | 1100 | 1100 | CM00000001  |
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | presroc | CM00000001  | LIC/NUM/CM02 | 9.00        |
      | credit          | presroc | CM00000001  | LIC/NUM/CM03 | 2.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb  | net | customerRef |
      | false | true  | 1100 | 1100 | 0   | CM00000001  |  
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

   Scenario: Transaction removed from invoice to make net total £0 is zero value (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 2.00        |
      | standard        | presroc | CM00000001  | LIC/NUM/CM02 | 150.00      |
      | standard        | presroc | CM00000001  | LIC/NUM/CM03 | 2.00        |
      | credit          | presroc | CM00000001  | LIC/NUM/CM04 | 2.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to delete the licence LIC/NUM/CM02 for CM00000001
     And bill run status is updated to "generated"
     And I request to delete the licence LIC/NUM/CM03 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net | customerRef |
      | false | true  | 200  | 200 | 0   | CM00000001  |  
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |     