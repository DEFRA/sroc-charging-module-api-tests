import { And, Then } from 'cypress-cucumber-preprocessor/steps'
import TransactionEndpoints from '../../../endpoints/transaction_endpoints'

And('I add a successful transaction with the following details', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const transactionType = row[0]
    const ruleset = row[1]
    const customerRef = row[2]
    const licenceNumber = row[3]
    const chargeValue = row[4]

    const fixtureName = `${transactionType}.${ruleset}.transaction`

    const uuid = require('uuid')
    const clientID = uuid.v4()

    const chargeAdjustment = chargeValue / 10

    cy.fixture(fixtureName).then((fixture) => {
      fixture.clientId = clientID
      fixture.customerReference = customerRef
      fixture.licenceNumber = licenceNumber

      if (ruleset === 'presroc') {
        fixture.section126Factor = chargeAdjustment
      } else {
        fixture.abatementFactor = chargeAdjustment
      }
      cy.wrap(fixture).as('fixture')
      cy.get('@billRun').then((billRun) => {
        TransactionEndpoints.create(billRun.id, fixture, false).then((response) => {
          expect(response.status).to.equal(201)
          expect(response.body).to.have.property('transaction')
          expect(response.body.transaction.id).not.to.equal(null)
          expect(response.body.transaction.clientId).not.to.equal(null)
        })
      })
    })
  })
})

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