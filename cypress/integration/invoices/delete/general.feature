Feature: Delete Invoice General

  Background: Authenticate
    Given I am the "system" user

  Scenario: Delete invoice successfully (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "initialised"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run does not contain any transactions

  Scenario: Delete debit invoice with credit invoice remaining (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | credit          | sroc    | CM00000002  | LIC/NUM/CM02 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 1 | 10000 | 0 | 0 | -10000 |

  Scenario: Delete debit invoice with small debit invoice remaining (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | sroc    | CM00000002  | LIC/NUM/CM02 | 8.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 800 | 800 |    
@ignore
  Scenario: Delete debit invoice with deminimis invoice remaining (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | sroc    | CM00000002  | LIC/NUM/CM02 | 2.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |
     And the bill run does contain transactions 

  Scenario: Delete debit invoice with zero value invoice remaining (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | sroc    | CM00000002  | LIC/NUM/CM02 | 2.00        |
      | credit          | sroc    | CM00000002  | LIC/NUM/CM02 | 2.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |
     And the bill run does contain transactions          

  Scenario: Delete credit invoice with debit invoice remaining (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | sroc    | CM00000002  | LIC/NUM/CM02 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 10000 | 10000 |
@ignore
  Scenario: Delete credit invoice with deminimis invoice remaining (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | sroc    | CM00000002  | LIC/NUM/CM02 | 2.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |
     And the bill run does contain transactions 

  Scenario: Delete credit invoice with zero value invoice remaining (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | sroc    | CM00000002  | LIC/NUM/CM02 | 2.00        |
      | credit          | sroc    | CM00000002  | LIC/NUM/CM02 | 2.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |
     And the bill run does contain transactions
@ignore
  Scenario: Delete Deminimis invoice with debit invoice remaining (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 7.99        |
      | standard        | sroc    | CM00000002  | LIC/NUM/CM02 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 10000 | 10000 |
@ignore
  Scenario: Delete Deminimis invoice with credit invoice remaining (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 7.99        |
      | credit          | sroc    | CM00000002  | LIC/NUM/CM02 | 10.00       |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 1 | 1000 | 0 | 0 | -1000 |
@ignore
  Scenario: Delete Deminimis invoice with zero value invoice remaining (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 7.99        |
      | standard        | sroc    | CM00000002  | LIC/NUM/CM02 | 2.00        |
      | credit          | sroc    | CM00000002  | LIC/NUM/CM02 | 2.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |
     And the bill run does contain transactions

  Scenario: Delete Zero value invoice with debit invoice remaining (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | sroc    | CM00000002  | LIC/NUM/CM02 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 10000 | 10000 |

  Scenario: Delete Zero value invoice with credit invoice remaining (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | credit          | sroc    | CM00000002  | LIC/NUM/CM02 | 100.00       |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 1 | 10000 | 0 | 0 | -10000 |
@ignore
  Scenario: Delete Zero value invoice with deminimis invoice remaining (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | sroc    | CM00000002  | LIC/NUM/CM02 | 2.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |
     And the bill run does contain transactions    

#PRESROC
  Scenario: Delete invoice successfully (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "initialised"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run does not contain any transactions

  Scenario: Delete debit invoice with credit invoice remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | credit          | presroc | CM00000002  | LIC/NUM/CM02 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 1 | 10000 | 0 | 0 | -10000 |

  Scenario: Delete debit invoice with deminimis invoice remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | presroc | CM00000002  | LIC/NUM/CM02 | 2.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |
     And the bill run does contain transactions 

  Scenario: Delete debit invoice with zero value invoice remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | presroc | CM00000002  | LIC/NUM/CM02 | 2.00        |
      | credit          | presroc | CM00000002  | LIC/NUM/CM02 | 2.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |
     And the bill run does contain transactions

  Scenario: Delete debit invoice with minimum charge invoice remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | minimumCharge   | presroc | CM00000002  | LIC/NUM/CM02 | 2.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 2500 | 2500 |
     And the bill run does contain transactions             

  Scenario: Delete credit invoice with debit invoice remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | presroc | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | presroc | CM00000002  | LIC/NUM/CM02 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 10000 | 10000 |

  Scenario: Delete credit invoice with deminimis invoice remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | presroc | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | presroc | CM00000002  | LIC/NUM/CM02 | 2.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |
     And the bill run does contain transactions 

  Scenario: Delete credit invoice with zero value invoice remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | presroc | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | presroc | CM00000002  | LIC/NUM/CM02 | 2.00        |
      | credit          | presroc | CM00000002  | LIC/NUM/CM02 | 2.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |
     And the bill run does contain transactions

  Scenario: Delete credit invoice with minimum charge invoice remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | presroc | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | minimumCharge   | presroc | CM00000002  | LIC/NUM/CM02 | 10.00       |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 2500 | 2500 |
     And the bill run does contain transactions

  Scenario: Delete Deminimis invoice with debit invoice remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 3.99        |
      | standard        | presroc | CM00000002  | LIC/NUM/CM02 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 10000 | 10000 |

  Scenario: Delete Deminimis invoice with credit invoice remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 3.99        |
      | credit          | presroc | CM00000002  | LIC/NUM/CM02 | 10.00       |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 1 | 1000 | 0 | 0 | -1000 |

  Scenario: Delete Deminimis invoice with zero value invoice remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 3.99        |
      | standard        | presroc | CM00000002  | LIC/NUM/CM02 | 2.00        |
      | credit          | presroc | CM00000002  | LIC/NUM/CM02 | 2.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |
     And the bill run does contain transactions

  Scenario: Delete Zero value invoice with debit invoice remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | credit          | presroc | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | presroc | CM00000002  | LIC/NUM/CM02 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 10000 | 10000 |

  Scenario: Delete Zero value invoice with credit invoice remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | credit          | presroc | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | credit          | presroc | CM00000002  | LIC/NUM/CM02 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 1 | 10000 | 0 | 0 | -10000 |

  Scenario: Delete Zero value invoice with deminimis invoice remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | credit          | presroc | CM00000001  | LIC/NUM/CM01 | 100.00      |
      | standard        | presroc | CM00000002  | LIC/NUM/CM02 | 2.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |
     And the bill run does contain transactions

  Scenario: Delete Minimum Charge invoice with debit invoice remaining (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | minimumCharge   | presroc | CM00000001  | LIC/NUM/CM01 | 3.99        |
      | standard        | presroc | CM00000002  | LIC/NUM/CM02 | 100.00      |
     And I request to generate the bill run
     And bill run status is updated to "generated" 
    Then I request to delete the invoice for CM00000001
     And bill run status is updated to "generated"
     And I try to view the invoice for CM00000001 I am told it no longer exists
     And I request to view the bill run
     And the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 10000 | 10000 |   
