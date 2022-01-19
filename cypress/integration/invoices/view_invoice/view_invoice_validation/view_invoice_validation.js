import { Then, And } from 'cypress-cucumber-preprocessor/steps'
import InvoiceEndpoints from '../../../../endpoints/invoice_endpoints'
import BillRunEndpoints from '../../../../endpoints/bill_run_endpoints'

Then('I request to view the invoice with an unknown invoice ID and I am told its unknown', () => {
  cy.get('@billRun').then((billRun) => {
    const billRunId = billRun.id

    const uuid = require('uuid')
    const invoiceId = uuid.v4()

    InvoiceEndpoints.view(billRunId, invoiceId, false).then((response) => {
      expect(response.status).to.be.equal(404)
      expect(response.body.message).to.be.equal(`Invoice ${invoiceId} is unknown.`)
    })
  })
})

Then('I request to view the invoice for {word} and I am told its unknown', () => {
  cy.get('@billRun').then((billRun) => {
    const billRunId = billRun.id

    const uuid = require('uuid')
    const invoiceId = uuid.v4()

    InvoiceEndpoints.view(billRunId, invoiceId, false).then((response) => {
      expect(response.status).to.be.equal(404)
      expect(response.body.message).to.be.equal(`Invoice ${invoiceId} is unknown.`)
    })
  })
})

And('I request to view the invoice for {word} and I am told its not linked to this bill run', (customerRef) => {
  cy.get('@billRun').then((billRun) => {
    const billRunId = billRun.id
    cy.get('@billRun1').then((billRun1) => {
      const billRunId1 = billRun1.id

      BillRunEndpoints.view(billRunId).then((response) => {
        expect(response.status).to.be.equal(200)
        cy.wrap(response.body.billRun).as('viewBillRun')

        cy.get('@viewBillRun').then((viewBillRun) => {
          const invoice = viewBillRun.invoices.find(element => element.customerReference === customerRef)
          const invoiceId = invoice.id
          InvoiceEndpoints.view(billRunId1, invoiceId, false).then((response) => {
            expect(response.status).to.be.equal(409)
            expect(response.body.message).to.be.equal(`Invoice ${invoiceId} is not linked to bill run ${billRunId1}.`)
          })
        })
      })
    })
  })
})
