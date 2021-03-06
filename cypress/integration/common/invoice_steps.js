import { And, Then } from 'cypress-cucumber-preprocessor/steps'
import InvoiceEndpoints from '../../endpoints/invoice_endpoints'
import BillRunEndpoints from '../../endpoints/bill_run_endpoints'

Then('the invoice summary includes the expected items', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const expectedDeminimis = row[0]
    const expectedZeroValue = row[1]
    const expectedCreditLineValue = Number(row[2])
    const expectedDebitLineValue = Number(row[3])
    const expectedNetTotal = Number(row[4])
    const customerRef = row[5]
    cy.log('Testing invoice summary items')
    cy.get('@viewBillRun').then((billRun) => {
      const invoice = billRun.invoices.find(element => element.customerReference === customerRef)

      expect(JSON.stringify(invoice.deminimisInvoice)).to.equal(expectedDeminimis)
      expect(JSON.stringify(invoice.zeroValueInvoice)).to.equal(expectedZeroValue)
      expect(invoice.creditLineValue).to.equal(expectedCreditLineValue)
      expect(invoice.debitLineValue).to.equal(expectedDebitLineValue)
      expect(invoice.netTotal).to.equal(expectedNetTotal)
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

And('I try to view the invoice for {word} I am told it no longer exists', (customerRef) => {
  cy.get('@billRun').then((billRun) => {
    const billRunId = billRun.id
    cy.get('@viewBillRun').then((viewBillRun) => {
      const invoice = viewBillRun.invoices.find(element => element.customerReference === customerRef)
      const invoiceId = invoice.id
      InvoiceEndpoints.view(billRunId, invoiceId, false).then((response) => {
        expect(response.status).to.be.equal(404)
        expect(response.body.message).to.be.equal(`Invoice ${invoiceId} is unknown.`)
      })
    })
  })
})

Then('the transaction reference is generated for {word}', (customerRef) => {
  cy.log('Checking transaction reference is generated')
  cy.get('@viewBillRun').then((billRun) => {
    const billRunId = billRun.id
    const invoice = billRun.invoices.find(element => element.customerReference === customerRef)
    const invoiceId = invoice.id

    // Testing at view bill run
    expect(invoice.transactionReference).to.not.equal(null)
    // Testing at view invoice
    InvoiceEndpoints.view(billRunId, invoiceId).then((response) => {
      cy.wrap(response.body).as('viewInvoice')
      expect(response.status).to.be.equal(200)
      expect(response.body.invoice.transactionReference).to.not.equal(null)
    })
  })
})
