Feature: Deminimis

  Background: Authenticate
    Given I am the "system" user 

#SROC deminimis threshold has been changed to £0

  Scenario: Invoice net total of £0.01 is not deminimis (SROC)
    When I request a valid new sroc bill run
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 0.01        |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net | customerRef |
      | false | false | 0    | 1   | 1   | CM00000001  | 
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 1 | 1 |

  Scenario: Invoice net total of £9.99 is not deminimis (SROC)
    When I request a valid new sroc bill run
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 9.99        |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net | customerRef |
      | false | false | 0    | 999 | 999 | CM00000001  | 
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 999| 999 |

  Scenario: Invoice net total of £10 is not deminimis (SROC)
    When I request a valid new sroc bill run
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 10          |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb  | net  | customerRef |
      | false | false | 0    | 1000 | 1000 | CM00000001  |  
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 1000 | 1000 |

  Scenario: Invoice net total of -£0.01 is not deminimis (SROC)
    When I request a valid new sroc bill run
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM01 | 0.01        |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net | customerRef |
      | false | false | 1    | 0   | -1  | CM00000001  |  
     And the bill run summary includes the expected items
      | generated | 1 | 1 | 0 | 0 | -1 |

  Scenario: Transaction added to invoice to make net total of under £10 is not deminimis (SROC)
    When I request a valid new sroc bill run
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 5.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM02 | 4.00        |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM03 | 1.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net | customerRef |
      | false | false | 100  | 900 | 800 | CM00000001  |  
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 800 | 800 |

  Scenario: Transaction removed from invoice to make net total of under £10 is not deminimis (SROC)
    When I request a valid new sroc bill run
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 8.00        |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM02 | 150.00      |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM03 | 10.00       |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to delete the licence LIC/NUM/CM02 for CM00000001
     And bill run status is updated to "generated"
     And I request to delete the licence LIC/NUM/CM03 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net | customerRef |
      | false | false | 0    | 800 | 800 | CM00000001  |  
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 800 | 800 |

  Scenario: Transaction removed from invoice to make net total of -£8 is not deminimis (SROC)
    When I request a valid new sroc bill run
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM01 | 8.00        |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM02 | 150.00      |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM03 | 10.00       |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to delete the licence LIC/NUM/CM02 for CM00000001
     And bill run status is updated to "generated"
     And I request to delete the licence LIC/NUM/CM03 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net  | customerRef |
      | false | false | 800  | 0   | -800 | CM00000001  |  
     And the bill run summary includes the expected items
      | generated | 1 | 800 | 0 | 0 | -800 |   

  Scenario: Transaction added to invoice to make net total of over £10 is not deminimis (SROC)
    When I request a valid new sroc bill run
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 5.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
     And the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net | customerRef |
      | false | false | 0    | 500 | 500 | CM00000001  |
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM02 | 120.00      |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM03 | 10.00       |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb   | net   | customerRef |
      | false | false | 1000 | 12500 | 11500 | CM00000001  |  
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 11500 | 11500 |
@ignore
  Scenario: Deminimis is calculated at invoice level (SROC)
    When I request a valid new sroc bill run
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 5.00        |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM11 | 4.00        |
      | standard        | sroc    | CM00000002  | LIC/NUM/CM02 | 15.00       |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to delete the invoice for CM00000002
     And bill run status is updated to "generated"
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000003  | LIC/NUM/CM03 | 25.00       |
      | standard        | sroc    | CM00000004  | LIC/NUM/CM04 | 9.99        |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run 
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 2500 | 2500 |

  Scenario: Low SROC debit invoice (previously demimimis) is billed (SROC)
    And I request a valid new sroc bill run
    And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 5.00        |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM02 | 4.00        |
    And I request to generate the bill run
    And bill run status is updated to "generated"
    And I request to view the bill run 
    And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 900 | 900 |
    And I request to approve the bill run
    And bill run status is updated to "approved"
    And I request to send the bill run
    And bill run status is updated to "billed" 

  Scenario: Invoice net total of £0.01 is deminimis (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 0.01        |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net | customerRef |
      | true  | false | 0    | 1   | 1   | CM00000001  |  
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Invoice net total of £4.99 is deminimis (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 4.99        |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net | customerRef |
      | true  | false | 0    | 499 | 499 | CM00000001  |  
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Invoice net total of £5 is not deminimis (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 5           |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net | customerRef |
      | false | false | 0    | 500 | 500 | CM00000001  |  
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 500 | 500 |

  Scenario: Invoice net total of -£0.01 is not deminimis (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | presroc | CM00000001  | LIC/NUM/CM01 | 0.01        |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net | customerRef |
      | false | false | 1    | 0   | -1  | CM00000001  |  
     And the bill run summary includes the expected items
      | generated | 1 | 1 | 0 | 0 | -1 |

  Scenario: Transaction added to invoice to make net total of under £5 is deminimis (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 3.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM02 | 2.00        |
      | credit          | presroc | CM00000001  | LIC/NUM/CM03 | 1.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net | customerRef |
      | true  | false | 100  | 500 | 400 | CM00000001  |  
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Transaction removed from invoice to make net total of under £5 is deminimis (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 2.00        |
      | standard        | presroc | CM00000001  | LIC/NUM/CM02 | 150.00      |
      | standard        | presroc | CM00000001  | LIC/NUM/CM03 | 10.00       |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to delete the licence LIC/NUM/CM02 for CM00000001
     And bill run status is updated to "generated"
     And I request to delete the licence LIC/NUM/CM03 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net | customerRef |
      | true  | false | 0    | 200 | 200 | CM00000001  |  
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Transaction removed from invoice to make net total of -£4 is not deminimis (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | presroc | CM00000001  | LIC/NUM/CM01 | 4.00        |
      | standard        | presroc | CM00000001  | LIC/NUM/CM02 | 150.00      |
      | standard        | presroc | CM00000001  | LIC/NUM/CM03 | 10.00       |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to delete the licence LIC/NUM/CM02 for CM00000001
     And bill run status is updated to "generated"
     And I request to delete the licence LIC/NUM/CM03 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net  | customerRef |
      | false | false | 400  | 0   | -400 | CM00000001  |  
     And the bill run summary includes the expected items
      | generated | 1 | 400 | 0 | 0 | -400 |   

  Scenario: Transaction added to invoice to make net total of over £5 is not deminimis (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 3.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
     And the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net |
      | true  | false | 0    | 300 | 300 | CM00000001  |
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM02 | 120.00      |
      | credit          | presroc | CM00000001  | LIC/NUM/CM03 | 10.00       |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb   | net   | customerRef |
      | false | false | 1000 | 12300 | 11300 | CM00000001  |  
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 11300 | 11300 |

  Scenario: Deminimis is calculated at invoice level (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 1.00        |
      | standard        | presroc | CM00000001  | LIC/NUM/CM11 | 3.00        |
      | standard        | presroc | CM00000002  | LIC/NUM/CM02 | 15.00       |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to delete the invoice for CM00000002
     And bill run status is updated to "generated"
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000003  | LIC/NUM/CM03 | 25.00       |
      | standard        | presroc | CM00000004  | LIC/NUM/CM04 | 2.00        |
      | standard        | presroc | CM00000004  | LIC/NUM/CM44 | 2.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run 
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 2500 | 2500 |    