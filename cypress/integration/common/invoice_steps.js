import { And, Then } from 'cypress-cucumber-preprocessor/steps'
import InvoiceEndpoints from '../../endpoints/invoice_endpoints'
import BillRunEndpoints from '../../endpoints/bill_run_endpoints'

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

And('I request to view the invoice for {word}', (customerRef) => {
  cy.get('@billRun').then((billRun) => {
    const billRunId = billRun.id

    BillRunEndpoints.view(billRunId).then((response) => {
      expect(response.status).to.be.equal(200)
      cy.wrap(response.body.billRun).as('viewBillRun')

      cy.get('@viewBillRun').then((viewBillRun) => {
        const invoice = viewBillRun.invoices.find(element => element.customerReference === customerRef)
        const invoiceId = invoice.id
        cy.wrap(invoice).as('invoice')

        InvoiceEndpoints.view(billRunId, invoiceId).then((response) => {
          expect(response.status).to.be.equal(200)
        })
      })
    })
  })
})

And('I request to delete the invoice for {word}', (customerRef) => {
  cy.get('@billRun').then((billRun) => {
    const billRunId = billRun.id

    BillRunEndpoints.view(billRunId).then((response) => {
      expect(response.status).to.be.equal(200)
      cy.wrap(response.body.billRun).as('viewBillRun')

      cy.get('@viewBillRun').then((viewBillRun) => {
        const invoice = viewBillRun.invoices.find(element => element.customerReference === customerRef)
        const invoiceId = invoice.id

        InvoiceEndpoints.delete(billRunId, invoiceId).then((response) => {
          expect(response.status).to.be.equal(204)
        })
      })
    })
  })
})