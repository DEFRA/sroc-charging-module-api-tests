Feature: View Bill Run General

  Background: Authenticate
    Given I am the "system" user

  Scenario: Viewing the bill run summary (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful sroc standard transaction for customer CM00000001
     And I request to generate the bill run
     And bill run status is updated to "generated" 
     And I request to view the bill run
    Then the bill run summary items are correct

  Scenario: Viewing the bill run summary (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful presroc standard transaction for customer CM00000001
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the bill run summary items are correct 

# Check invoice summary
# The values in the table relate to what will be sent in the request for
# | transactionType | ruleset | customerReference | 
# The second set of values in the table relate to what values should be for
# | deminimisInvoice | zeroValueInvoice |
  Scenario: Invoice summary shows expected items for debit invoice (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 180.00      | 
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb   | net   | customerRef |
      | false | false | 0    | 18000 | 18000 | CM00000001  |

  Scenario: Invoice summary shows expected items for credit invoice (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM01 | 180.00      | 
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred  | deb | net    | customerRef |
      | false | false | 18000 | 0   | -18000 | CM00000001  |    

  Scenario: Invoice summary shows expected items for deminimis invoice (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 9.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net | customerRef |
      | true  | false | 0    | 900 | 900 | CM00000001  |  

  Scenario: Invoice summary shows expected items for zero value invoice (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | sroc    | CM00000001  | LIC/NUM/CM01 | 90.00       |
      | credit          | sroc    | CM00000001  | LIC/NUM/CM01 | 90.00       |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb  | net | customerRef |
      | false | true  | 9000 | 9000 | 0   | CM00000001  |

  Scenario: Invoice summary shows expected items for debit invoice (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 180.00      | 
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb   | net   | customerRef |
      | false | false | 0    | 18000 | 18000 | CM00000001  |

  Scenario: Invoice summary shows expected items for credit invoice (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | credit          | presroc | CM00000001  | LIC/NUM/CM01 | 180.00      | 
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred  | deb | net    | customerRef |
      | false | false | 18000 | 0   | -18000 | CM00000001  |    

  Scenario: Invoice summary shows expected items for deminimis invoice (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 4.00        |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb | net | customerRef |
      | true  | false | 0    | 400 | 400 | CM00000001  |  

  Scenario: Invoice summary shows expected items for zero value invoice (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
     #| transactionType | ruleset | customerRef | licenceNum   | chargeValue |
      | standard        | presroc | CM00000001  | LIC/NUM/CM01 | 90.00       |
      | credit          | presroc | CM00000001  | LIC/NUM/CM01 | 90.00       |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary includes the expected items
     #| demin | zeroV | cred | deb  | net | customerRef |
      | false | true  | 9000 | 9000 | 0   | CM00000001  |    

  Scenario: Invoice summary does not include minimum charge flag (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful sroc minimumCharge transaction for customer CM00000001
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary does not count this as a minimum charge invoice

  Scenario: Invoice summary includes minimum charge flag (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful presroc minimumCharge transaction for customer CM00000001
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the invoice summary counts this as a minimum charge invoice    

# Check Bill run summary
# The values in the table relate to what will be sent in the request for
# | transactionType | ruleset | customerReference | 
# The second set of values in the table relate to what values should be for
# | status | creditNoteCount | creditNoteValue | invoiceCount | invoiceValue |
  Scenario: Bill run summary correctly shows debit invoices (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful sroc standard transaction for customer CM00000001
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 1000 | 1000 |
  
  Scenario: Bill run summary correctly shows credit invoices (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful sroc credit transaction for customer CM00000001
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 1 | 1000 | 0 | 0 | -1000 |
 
  Scenario: Bill run summary excludes de-minimus invoices (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful sroc deminimis transaction for customer CM00000001
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Bill run summary excludes zero value invoices (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful sroc standard transaction for customer CM00000001 
     And I add a successful sroc credit transaction for customer CM00000001
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Bill run summary excludes de-minimus invoices (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful presroc deminimis transaction for customer CM00000001
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Bill run summary excludes zero value invoices (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful presroc standard transaction for customer CM00000001 
     And I add a successful presroc credit transaction for customer CM00000001
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |    

# Check grouping by invoice
  Scenario: New invoice not created if customer ref, financial year and licence numbers are the same
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following FY details
      | standard | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM01 |
      | standard | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM01 |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 2000 | 2000 |
     And the count of invoices in the bill run are 1  

  Scenario: New invoice not created if customer ref, financial year and licence numbers are different
    When I request a valid new sroc bill run
     And I add a successful transaction with the following FY details
      | standard | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM01 |
      | standard | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM02 |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 2000 | 2000 |
     And the count of invoices in the bill run are 1 
@ignore
#new ruleset not available yet
  Scenario: New invoice created for same customer ref and different financial years
    When I request a valid new sroc bill run
     And I add a successful transaction with the following FY details
      | standard | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM01 |
      | standard | sroc | CM00000001 | 01-APR-2022 | 31-MAR-2023 | LIC/NUM/CM01 |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 2 | 2000 | 2000 |
     And the count of invoices in the bill run are 2

  Scenario: New invoice created for same financial year and different customer ref
    When I request a valid new sroc bill run
     And I add a successful transaction with the following FY details
      | standard | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM01 |
      | standard | sroc | CM00000002 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM01 |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 2 | 2000 | 2000 |
     And the count of invoices in the bill run are 2 

# Check grouping by licence
  Scenario: New licence is not created if customer ref, financial year and licence numbers are the same
    When I request a valid new sroc bill run
     And I add a successful transaction with the following FY details
      | standard  | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM01 |
      | zeroValue | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM01 |
      | credit    | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM01 |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |
     And the count of licences in the invoice for CM00000001 are 1 

  Scenario: New licence is created if customer ref, financial year and licence numbers are different
    When I request a valid new sroc bill run
     And I add a successful transaction with the following FY details
      | standard  | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM01 |
      | zeroValue | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM02 |
      | credit    | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM03 |
     And I request to generate the bill run
     And bill run status is updated to "generated"
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |
     And the count of licences in the invoice for CM00000001 are 3