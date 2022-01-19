Feature: Delete Licence General

  Background: Authenticate
    Given I am the "system" user

  Scenario: Delete licence successfully (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     #And bill run status is updated to "initialised" 
     And I request to view the bill run
    Then the bill run does not contain any transactions

  Scenario: Delete debit licence with debit licence remaining (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM02 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then licence LIC/NUM/CM01 is no longer listed under invoice CM00000001
     And the invoice summary includes the expected items
     #| demin | zeroV | cred | deb   | net   |
      | false | false | 0    | 10000 | 10000 |
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 10000 | 10000 |

  Scenario: Delete debit licence with credit licence remaining (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM02 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then licence LIC/NUM/CM01 is no longer listed under invoice CM00000001
     And the invoice summary includes the expected items
     #| demin | zeroV | cred  | deb | net    |
      | false | false | 10000 | 0   | -10000 |
     And the bill run summary includes the expected items
      | generated | 1 | 10000 | 0 | 0 | -10000 |

  Scenario: Delete debit licence with deminimis remaining (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM02 | 7.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then licence LIC/NUM/CM01 is no longer listed under invoice CM00000001
     And the invoice summary includes the expected items
     #| demin | zeroV | cred | deb   | net | 
      | true  | false | 0    | 700   | 700 |
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Delete debit licence with zero value licence remaining (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM02 | 100.00      |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM03 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then licence LIC/NUM/CM01 is no longer listed under invoice CM00000001
     And the invoice summary includes the expected items
     #| demin | zeroV | cred  | deb   | net |
      | false | true  | 10000 | 10000 | 0   |
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Delete credit licence with credit licence remaining (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM02 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then licence LIC/NUM/CM01 is no longer listed under invoice CM00000001
     And the invoice summary includes the expected items
     #| demin | zeroV | cred  | deb | net    |
      | false | false | 10000 | 0   | -10000 |
     And the bill run summary includes the expected items
      | generated | 1 | 10000 | 0 | 0 | -10000 |

  Scenario: Delete credit licence with debit licence remaining (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM02 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then licence LIC/NUM/CM01 is no longer listed under invoice CM00000001
     And the invoice summary includes the expected items
     #| demin | zeroV | cred | deb   | net   |
      | false | false | 0    | 10000 | 10000 |
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 10000 | 10000 |

  Scenario: Delete credit licence with deminimis remaining (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM02 | 7.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then licence LIC/NUM/CM01 is no longer listed under invoice CM00000001
     And the invoice summary includes the expected items
     #| demin | zeroV | cred | deb   | net | 
      | true  | false | 0    | 700   | 700 |
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Delete credit licence with zero value licence remaining (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM02 | 100.00      |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM03 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then licence LIC/NUM/CM01 is no longer listed under invoice CM00000001
     And the invoice summary includes the expected items
     #| demin | zeroV | cred  | deb   | net |
      | false | true  | 10000 | 10000 | 0   |
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Delete zero value licence with debit licence remaining (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM02 | 0.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then licence LIC/NUM/CM01 is no longer listed under invoice CM00000001
     And the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net |
      | false | true  | 0    | 0   | 0   |
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Delete zero value licence with credit licence remaining (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM02 | 0.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then licence LIC/NUM/CM01 is no longer listed under invoice CM00000001
     And the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net |
      | false | true  | 0    | 0   | 0   |
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Invoice is deleted when last remaining licence is deleted leaving a debit invoice in the bill run (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | sroc    | CM00000002  | LIC/NUM/CM02 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then invoice CM00000001 is no longer listed under the bill run
     And the invoice summary includes the expected items
     #| demin | zeroV | cred  | deb   | net   |
      | false | false | 0     | 10000 | 10000 |
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 10000 | 10000 |    

  Scenario: Invoice is deleted when last remaining licence is deleted leaving a credit invoice in the bill run (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | credit          | sroc    | CM00000002  | LIC/NUM/CM02 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then invoice CM00000001 is no longer listed under the bill run
     And the invoice summary includes the expected items
     #| demin | zeroV | cred  | deb | net    |
      | false | false | 10000 | 0   | -10000 |
     And the bill run summary includes the expected items
      | generated | 1 | 10000 | 0 | 0 | -10000 |

  Scenario: Invoice is deleted when last remaining licence is deleted leaving a deminimis invoice in the bill run (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | sroc    | CM00000002  | LIC/NUM/CM02 | 8.99        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then invoice CM00000001 is no longer listed under the bill run
     And the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net |
      | true  | false | 0    | 899 | 899 |
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Invoice is deleted when last remaining licence is deleted leaving a zero value invoice in the bill run (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | sroc    | CM00000002  | LIC/NUM/CM02 | 0.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then invoice CM00000001 is no longer listed under the bill run
     And the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net |
      | false | true  | 0    | 0   | 0   |
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |    

#PRESROC
  Scenario: Delete licence successfully (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset    | customerRef | licenceNum   | chargeValue |
      | standard        | presroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     #And bill run status is updated to "initialised" 
     And I request to view the bill run
    Then the bill run does not contain any transactions

  Scenario: Delete debit licence with debit licence remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset    | customerRef | licenceNum   | chargeValue |
      | standard        | presroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | presroc    | CM00000001  | LIC/NUM/CM02 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then licence LIC/NUM/CM01 is no longer listed under invoice CM00000001
     And the invoice summary includes the expected items
     #| demin | zeroV | cred | deb   | net   |
      | false | false | 0    | 10000 | 10000 |
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 10000 | 10000 |

  Scenario: Delete debit licence with credit licence remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset    | customerRef | licenceNum   | chargeValue |
      | standard        | presroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | credit          | presroc    | CM00000001  | LIC/NUM/CM02 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then licence LIC/NUM/CM01 is no longer listed under invoice CM00000001
     And the invoice summary includes the expected items
     #| demin | zeroV | cred  | deb | net    |
      | false | false | 10000 | 0   | -10000 |
     And the bill run summary includes the expected items
      | generated | 1 | 10000 | 0 | 0 | -10000 |

  Scenario: Delete debit licence with deminimis remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset    | customerRef | licenceNum   | chargeValue |
      | standard        | presroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | presroc    | CM00000001  | LIC/NUM/CM02 | 4.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then licence LIC/NUM/CM01 is no longer listed under invoice CM00000001
     And the invoice summary includes the expected items
     #| demin | zeroV | cred | deb   | net | 
      | true  | false | 0    | 400   | 400 |
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Delete debit licence with zero value licence remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset    | customerRef | licenceNum   | chargeValue |
      | standard        | presroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | presroc    | CM00000001  | LIC/NUM/CM02 | 100.00      |
      | credit          | presroc    | CM00000001  | LIC/NUM/CM03 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then licence LIC/NUM/CM01 is no longer listed under invoice CM00000001
     And the invoice summary includes the expected items
     #| demin | zeroV | cred  | deb   | net |
      | false | true  | 10000 | 10000 | 0   |
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Delete credit licence with credit licence remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset    | customerRef | licenceNum   | chargeValue |
      | credit          | presroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | credit          | presroc    | CM00000001  | LIC/NUM/CM02 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then licence LIC/NUM/CM01 is no longer listed under invoice CM00000001
     And the invoice summary includes the expected items
     #| demin | zeroV | cred  | deb | net    |
      | false | false | 10000 | 0   | -10000 |
     And the bill run summary includes the expected items
      | generated | 1 | 10000 | 0 | 0 | -10000 |

  Scenario: Delete credit licence with debit licence remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset    | customerRef | licenceNum   | chargeValue |
      | credit          | presroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | presroc    | CM00000001  | LIC/NUM/CM02 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then licence LIC/NUM/CM01 is no longer listed under invoice CM00000001
     And the invoice summary includes the expected items
     #| demin | zeroV | cred | deb   | net   |
      | false | false | 0    | 10000 | 10000 |
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 10000 | 10000 |

  Scenario: Delete credit licence with deminimis remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset    | customerRef | licenceNum   | chargeValue |
      | credit          | presroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | presroc    | CM00000001  | LIC/NUM/CM02 | 4.99        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then licence LIC/NUM/CM01 is no longer listed under invoice CM00000001
     And the invoice summary includes the expected items
     #| demin | zeroV | cred | deb   | net | 
      | true  | false | 0    | 499   | 499 |
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Delete credit licence with zero value licence remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset    | customerRef | licenceNum   | chargeValue |
      | credit          | presroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | credit          | presroc    | CM00000001  | LIC/NUM/CM02 | 100.00      |
      | standard        | presroc    | CM00000001  | LIC/NUM/CM03 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then licence LIC/NUM/CM01 is no longer listed under invoice CM00000001
     And the invoice summary includes the expected items
     #| demin | zeroV | cred  | deb   | net |
      | false | true  | 10000 | 10000 | 0   |
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Delete zero value licence with debit licence remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset    | customerRef | licenceNum   | chargeValue |
      | standard        | presroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | presroc    | CM00000001  | LIC/NUM/CM02 | 0.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then licence LIC/NUM/CM01 is no longer listed under invoice CM00000001
     And the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net |
      | false | true  | 0    | 0   | 0   |
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Delete zero value licence with credit licence remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset    | customerRef | licenceNum   | chargeValue |
      | credit          | presroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | presroc    | CM00000001  | LIC/NUM/CM02 | 0.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then licence LIC/NUM/CM01 is no longer listed under invoice CM00000001
     And the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net |
      | false | true  | 0    | 0   | 0   |
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Invoice is deleted when last remaining licence is deleted leaving a debit invoice in the bill run (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset    | customerRef | licenceNum   | chargeValue |
      | standard        | presroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | presroc    | CM00000002  | LIC/NUM/CM02 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then invoice CM00000001 is no longer listed under the bill run
     And the invoice summary includes the expected items
     #| demin | zeroV | cred  | deb   | net   |
      | false | false | 0     | 10000 | 10000 |
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 10000 | 10000 |    

  Scenario: Invoice is deleted when last remaining licence is deleted leaving a credit invoice in the bill run (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset    | customerRef | licenceNum   | chargeValue |
      | standard        | presroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | credit          | presroc    | CM00000002  | LIC/NUM/CM02 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then invoice CM00000001 is no longer listed under the bill run
     And the invoice summary includes the expected items
     #| demin | zeroV | cred  | deb | net    |
      | false | false | 10000 | 0   | -10000 |
     And the bill run summary includes the expected items
      | generated | 1 | 10000 | 0 | 0 | -10000 |

  Scenario: Invoice is deleted when last remaining licence is deleted leaving a deminimis invoice in the bill run (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset    | customerRef | licenceNum   | chargeValue |
      | standard        | presroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | presroc    | CM00000002  | LIC/NUM/CM02 | 1.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then invoice CM00000001 is no longer listed under the bill run
     And the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net |
      | true  | false | 0    | 100 | 100 |
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Invoice is deleted when last remaining licence is deleted leaving a zero value invoice in the bill run (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset    | customerRef | licenceNum   | chargeValue |
      | standard        | presroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | presroc    | CM00000002  | LIC/NUM/CM02 | 0.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to delete the licence LIC/NUM/CM01 for CM00000001
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then invoice CM00000001 is no longer listed under the bill run
     And the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net |
      | false | true  | 0    | 0   | 0   |
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 | 