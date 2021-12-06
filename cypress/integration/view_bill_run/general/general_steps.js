import { And, Then } from 'cypress-cucumber-preprocessor/steps'
import TransactionEndpoints from '../../../endpoints/transaction_endpoints'

Then('the bill run summary items are correct', () => {
  cy.log('Testing Bill run summary items')

  cy.get('@billRunRegion').then((billRunRegion) => {
    const region = billRunRegion
    cy.get('@rulesetType').then((rulesetType) => {
      const ruleset = rulesetType

      cy.get('@billRun').then((billRun) => {
        const billRunId = billRun.id
        const billRunNumber = billRun.billRunNumber
        cy.get('@viewBillRun').then((billRun) => {
          expect(billRun.id).to.equal(billRunId)
          expect(billRun.billRunNumber).to.equal(billRunNumber)
          expect(billRun.ruleset).to.equal(ruleset)
          expect(billRun.region).to.equal(region)
          expect(billRun.transactionFileReference).to.equal(null)
        })
      })
    })
  })
})

Then('the bill run summary includes the expected items', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const status = row[0]
    const expectedCreditNoteCount = Number(row[1])
    const expectedCreditNoteValue = Number(row[2])
    const expectedInvoiceCount = Number(row[3])
    const expectedInvoiceValue = Number(row[4])
    const expectedNetTotal = Number(row[5])
    cy.log('Testing Bill run summary items')

    cy.get('@viewBillRun').then((billRun) => {
      expect(billRun.status).to.equal(status)
      expect(billRun.creditNoteCount).to.equal(expectedCreditNoteCount)
      expect(billRun.creditNoteValue).to.equal(expectedCreditNoteValue)
      expect(billRun.invoiceCount).to.equal(expectedInvoiceCount)
      expect(billRun.invoiceValue).to.equal(expectedInvoiceValue)
      expect(billRun.netTotal).to.equal(expectedNetTotal)
    })
  })
})

Then('the invoice summary includes the expected items', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const expectedDeminimis = row[0]
    const expectedZeroValue = row[1]
    cy.log('Testing invoice summary items')

    cy.get('@fixture').then((fixture) => {
      const customerRef = fixture.customerReference
      cy.get('@viewBillRun').then((billRun) => {
        const invoice = billRun.invoices.find(element => element.customerReference === customerRef)

        expect(JSON.stringify(invoice.deminimisInvoice)).to.equal(expectedDeminimis)
        expect(JSON.stringify(invoice.zeroValueInvoice)).to.equal(expectedZeroValue)
      })
    })
  })
})

And('the count of invoices in the bill run are {int}', (expInvoiceCount) => {
    cy.log('Testing count of invoices in bill run')

      cy.get('@viewBillRun').then((billRun) => {
        const jsonObject = billRun.invoices
        const invoiceCount  = Object.keys(jsonObject).length;

        expect(invoiceCount).to.equal(expInvoiceCount)
      })
    })

And('the count of licences in the invoice for {word} are {int}', (customerRef, expLicenceCount) => {
      cy.log('Testing count of invoices in bill run')

        cy.get('@viewBillRun').then((billRun) => {
          const invoice = billRun.invoices.find(element => element.customerReference === customerRef)
          
          const jsonObject = invoice.licences
          const licenceCount  = Object.keys(jsonObject).length;
  
          expect(licenceCount).to.equal(expLicenceCount)
        })
      })

Then('the invoice summary does not count this as a minimum charge invoice', () => {
  cy.log('Testing invoice summary does not include Minimum Charge invoice')

  cy.get('@fixture').then((fixture) => {
    const customerRef = fixture.customerReference
    cy.get('@viewBillRun').then((billRun) => {
      const invoice = billRun.invoices.find(element => element.customerReference === customerRef)
      expect(JSON.stringify(invoice)).to.not.include('minimumChargeInvoice')
    })
  })
})

Then('the invoice summary counts this as a minimum charge invoice', () => {
  cy.log('Testing invoice summary includes Minimum Charge invoice')

  cy.get('@fixture').then((fixture) => {
    const customerRef = fixture.customerReference
    cy.get('@viewBillRun').then((billRun) => {
      const invoice = billRun.invoices.find(element => element.customerReference === customerRef)
      expect(invoice.minimumChargeInvoice).to.equal(true)
    })
  })
})
