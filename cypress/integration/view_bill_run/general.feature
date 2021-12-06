Feature: View Bill Run General

  Background: Authenticate
    Given I am the "system" user

  Scenario: Viewing the bill run summary (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful sroc standard transaction for customer CM00000001
     And I request to generate the bill run 
     And I request to view the bill run
    Then the bill run summary items are correct

  Scenario: Viewing the bill run summary (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful presroc standard transaction for customer CM00000001
     And I request to generate the bill run 
     And I request to view the bill run
    Then the bill run summary items are correct 

# The values in the table relate to what will be sent in the request for
# | transactionType | ruleset | customerReference | 
# The second set of values in the table relate to what values should be for
# | deminimisInvoice | zeroValueInvoice |
  Scenario: Invoice summary shows expected items for standard transaction (SROC)
    When I request a valid new sroc bill run
     And I add a successful sroc standard transaction for customer CM00000001 
     And I request to generate the bill run
     And I request to view the bill run
    Then the invoice summary includes the expected items
      | false | false |

  Scenario: Invoice summary shows expected items for deminimis invoice (SROC)
    When I request a valid new sroc bill run
     And I add a successful sroc deminimis transaction for customer CM00000001
     And I request to generate the bill run
     And I request to view the bill run
    Then the invoice summary includes the expected items
      | true | false |    

  Scenario: Invoice summary shows expected items for zero value invoice (SROC)
    When I request a valid new sroc bill run
     And I add a successful sroc standard transaction for customer CM00000001 
     And I add a successful sroc credit transaction for customer CM00000001 
     And I request to generate the bill run
     And I request to view the bill run
    Then the invoice summary includes the expected items
      | false | true |

  Scenario: Invoice summary shows expected items for standard transaction (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful presroc standard transaction for customer CM00000001
     And I request to generate the bill run
     And I request to view the bill run
    Then the invoice summary includes the expected items
      | false | false |

  Scenario: Invoice summary shows expected items for deminimis invoice (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful presroc deminimis transaction for customer CM00000001
     And I request to generate the bill run
     And I request to view the bill run
    Then the invoice summary includes the expected items
      | true | false |    

  Scenario: Invoice summary shows expected items for zero value invoice (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful presroc standard transaction for customer CM00000001 
     And I add a successful presroc credit transaction for customer CM00000001
     And I request to generate the bill run
     And I request to view the bill run
    Then the invoice summary includes the expected items
      | false | true |    

  Scenario: Invoice summary does not include minimum charge flag (SROC)
    When I request a valid new sroc bill run
     And I add a successful sroc minimumCharge transaction for customer CM00000001
     And I request to generate the bill run
     And I request to view the bill run
    Then the invoice summary does not count this as a minimum charge invoice

  Scenario: Invoice summary includes minimum charge flag (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful presroc minimumCharge transaction for customer CM00000001
     And I request to generate the bill run
     And I request to view the bill run
    Then the invoice summary counts this as a minimum charge invoice    

# The values in the table relate to what will be sent in the request for
# | transactionType | ruleset | customerReference | 
# The second set of values in the table relate to what values should be for
# | status | creditNoteCount | creditNoteValue | invoiceCount | invoiceValue |
  Scenario: Bill run summary correctly shows debit invoices (SROC)
    When I request a valid new sroc bill run
     And I add a successful sroc standard transaction for customer CM00000001
     And I request to generate the bill run
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 1994 | 1994 |
  
  Scenario: Bill run summary correctly shows credit invoices (SROC)
    When I request a valid new sroc bill run
     And I add a successful sroc credit transaction for customer CM00000001
     And I request to generate the bill run
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 1 | 1994 | 0 | 0 | -1994 |
 
  Scenario: Bill run summary excludes de-minimus invoices (SROC)
    When I request a valid new sroc bill run
     And I add a successful sroc deminimis transaction for customer CM00000001
     And I request to generate the bill run
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Bill run summary excludes zero value invoices (SROC)
    When I request a valid new sroc bill run
     And I add a successful sroc standard transaction for customer CM00000001 
     And I add a successful sroc credit transaction for customer CM00000001
     And I request to generate the bill run
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Bill run summary excludes de-minimus invoices (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful presroc deminimis transaction for customer CM00000001
     And I request to generate the bill run
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Bill run summary excludes zero value invoices (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful presroc standard transaction for customer CM00000001 
     And I add a successful presroc credit transaction for customer CM00000001
     And I request to generate the bill run
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |    

  Scenario: New invoice not created if customer ref, financial year and licence numbers are the same
    When I request a valid new sroc bill run
     And I add a successful transaction with the following details
      | standard | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM01 |
      | standard | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM01 |
     And I request to generate the bill run
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 3988 | 3988 |
     And the count of invoices in the bill run are 1  

  Scenario: New invoice not created if customer ref, financial year and licence numbers are different
    When I request a valid new sroc bill run
     And I add a successful transaction with the following details
      | standard | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM01 |
      | standard | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM02 |
     And I request to generate the bill run
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 1 | 3988 | 3988 |
     And the count of invoices in the bill run are 1 
@ignore 
#new ruleset not available yet
  Scenario: New invoice created for same customer ref and different financial years
    When I request a valid new sroc bill run
     And I add a successful transaction with the following details
      | standard | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM01 |
      | standard | sroc | CM00000001 | 01-APR-2022 | 31-MAR-2023 | LIC/NUM/CM01 |
     And I request to generate the bill run
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 2 | 3988 | 3988 |
     And the count of invoices in the bill run are 2

  Scenario: New invoice created for same financial year and different customer ref
    When I request a valid new sroc bill run
     And I add a successful transaction with the following details
      | standard | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM01 |
      | standard | sroc | CM00000002 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM01 |
     And I request to generate the bill run
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 2 | 3988 | 3988 |
     And the count of invoices in the bill run are 2 

#licence grouping
  Scenario: New licence is not created if customer ref, financial year and licence numbers are the same
    When I request a valid new sroc bill run
     And I add a successful transaction with the following details
      | standard  | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM01 |
      | zeroValue | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM01 |
      | credit    | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM01 |
     And I request to generate the bill run
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |
     And the count of licences in the invoice for CM00000001 are 1 

  Scenario: New licence is created if customer ref, financial year and licence numbers are different
    When I request a valid new sroc bill run
     And I add a successful transaction with the following details
      | standard  | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM01 |
      | zeroValue | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM02 |
      | credit    | sroc | CM00000001 | 01-APR-2021 | 31-MAR-2022 | LIC/NUM/CM03 |
     And I request to generate the bill run
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |
     And the count of licences in the invoice for CM00000001 are 3    