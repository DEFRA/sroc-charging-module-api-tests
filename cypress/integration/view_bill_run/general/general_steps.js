import { And, Then } from 'cypress-cucumber-preprocessor/steps'
import TransactionEndpoints from '../../../endpoints/transaction_endpoints'

And('I add a successful transaction with the following FY details', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const transactionType = row[0]
    const ruleset = row[1]
    const customerRef = row[2]
    const periodStart = row[3]
    const periodEnd = row[4]
    const licenceNumber = row[5]

    const fixtureName = `${transactionType}.${ruleset}.transaction`

    const uuid = require('uuid')
    const clientID = uuid.v4()

    cy.fixture(fixtureName).then((fixture) => {
      fixture.clientId = clientID
      fixture.customerReference = customerRef
      fixture.periodStart = periodStart
      fixture.periodEnd = periodEnd
      fixture.licenceNumber = licenceNumber
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

And('the count of invoices in the bill run are {int}', (expInvoiceCount) => {
  cy.log('Testing count of invoices in bill run')

  cy.get('@viewBillRun').then((billRun) => {
    const jsonObject = billRun.invoices
    const invoiceCount = Object.keys(jsonObject).length

    expect(invoiceCount).to.equal(expInvoiceCount)
  })
})

And('the count of licences in the invoice for {word} are {int}', (customerRef, expLicenceCount) => {
  cy.log('Testing count of invoices in bill run')

  cy.get('@viewBillRun').then((billRun) => {
    const invoice = billRun.invoices.find(element => element.customerReference === customerRef)

    const jsonObject = invoice.licences
    const licenceCount = Object.keys(jsonObject).length

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
