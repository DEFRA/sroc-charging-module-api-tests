Feature: View Bill Run General

  Background: Authenticate
    Given I am the "system" user

  Scenario: Viewing the bill run summary (SROC)
    When I request a valid new sroc bill run for region A
     And I add a successful transaction with the following details
      | standard  | sroc | CM00000001 |
     And I request to generate the bill run 
     And I request to view the bill run
    Then the bill run summary items are correct

  Scenario: Viewing the bill run summary (PRESROC)
    When I request a valid new presroc bill run for region A
     And I add a successful transaction with the following details
      | standard  | presroc | CM00000001 |
     And I request to generate the bill run 
     And I request to view the bill run
    Then the bill run summary items are correct 

# The values in the table relate to what will be sent in the request for
# | transactionType | ruleset | customerReference | 
# The second set of values in the table relate to what values should be for
# | deminimisInvoice | zeroValueInvoice |
  Scenario: Invoice summary shows expected items for standard transaction (SROC)
    When I request a valid new sroc bill run
     And I add a successful transaction with the following details
      | standard  | sroc | CM00000001 |
     And I request to generate the bill run
     And I request to view the bill run
    Then the invoice summary includes the expected items
      | false | false |

  Scenario: Invoice summary shows expected items for deminimis invoice (SROC)
    When I request a valid new sroc bill run
     And I add a successful transaction with the following details
      | deminimis  | sroc | CM00000001 |
     And I request to generate the bill run
     And I request to view the bill run
    Then the invoice summary includes the expected items
      | true | false |    

  Scenario: Invoice summary shows expected items for zero value invoice (SROC)
    When I request a valid new sroc bill run
     And I add a successful transaction with the following details
      | standard | sroc | CM00000001 |
      | credit   | sroc | CM00000001 |
     And I request to generate the bill run
     And I request to view the bill run
    Then the invoice summary includes the expected items
      | false | true |

  Scenario: Invoice summary shows expected items for standard transaction (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful transaction with the following details
      | standard  | presroc | CM00000001 |
     And I request to generate the bill run
     And I request to view the bill run
    Then the invoice summary includes the expected items
      | false | false |

  Scenario: Invoice summary shows expected items for deminimis invoice (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful transaction with the following details
      | deminimis  | presroc | CM00000001 |
     And I request to generate the bill run
     And I request to view the bill run
    Then the invoice summary includes the expected items
      | true | false |    

  Scenario: Invoice summary shows expected items for zero value invoice (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful transaction with the following details
      | standard | presroc | CM00000001 |
      | credit   | presroc | CM00000001 |
     And I request to generate the bill run
     And I request to view the bill run
    Then the invoice summary includes the expected items
      | false | true |    

  Scenario: Invoice summary does not include minimum charge flag (SROC)
    When I request a valid new sroc bill run
     And I add a successful sroc standard transaction with subjectToMinimumCharge as true for customer CM00000001
     And I request to generate the bill run
     And I request to view the bill run
    Then the invoice summary does not count this as a minimum charge invoice

  Scenario: Invoice summary includes minimum charge flag (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful presroc standard transaction with subjectToMinimumCharge as true for customer CM00000001
     And I request to generate the bill run
     And I request to view the bill run
    Then the invoice summary counts this as a minimum charge invoice    

# The values in the table relate to what will be sent in the request for
# | transactionType | ruleset | customerReference | 
# The second set of values in the table relate to what values should be for
# | status | creditNoteCount | creditNoteValue | invoiceCount | invoiceValue |
  Scenario: Bill run summary excludes de-minimus invoices (SROC)
    When I request a valid new sroc bill run
     And I add a successful transaction with the following details
      | deminimis  | sroc | CM00000001 |
     And I request to generate the bill run
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Bill run summary excludes zero value invoices (SROC)
    When I request a valid new sroc bill run
     And I add a successful transaction with the following details
      | standard | sroc | CM00000001 |
      | credit   | sroc | CM00000001 |
     And I request to generate the bill run
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Bill run summary excludes de-minimus invoices (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful transaction with the following details
      | deminimis  | presroc | CM00000001 |
     And I request to generate the bill run
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |

  Scenario: Bill run summary excludes zero value invoices (PRESROC)
    When I request a valid new presroc bill run
     And I add a successful transaction with the following details
      | standard | presroc | CM00000001 |
      | credit   | presroc | CM00000001 |
     And I request to generate the bill run
     And I request to view the bill run
    Then the bill run summary includes the expected items
      | generated | 0 | 0 | 0 | 0 | 0 |    


#invoice grouping
    
    #SROC
    # Same invoice if:
    #-> 2 transactions with same financial year and customer ref
    #-> 2 transactions with same financial year and customer ref and licence numbers
    #-> 2 transactions with same financial year and customer ref but different licence numbers

    # New invoice if:
    #-> same financial year different customer ref
    #-> same customer ref different fin year 

#licence grouping
