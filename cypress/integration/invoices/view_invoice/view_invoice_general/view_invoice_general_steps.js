import { Then } from 'cypress-cucumber-preprocessor/steps'
import InvoiceEndpoints from '../../../../endpoints/invoice_endpoints'

Then('the invoice level items are correct for a {word} invoice', (invoiceType) => {
    cy.log('Checking View invoice level items')
    cy.get('@billRun').then((billRun) => {
      const billRunId = billRun.id
      cy.get('@rulesetType').then((rulesetType) => {
        const ruleset = rulesetType
        cy.get('@invoice').then((billRunInvoice) => {
          const invoiceId = billRunInvoice.id
          cy.get('@fixture').then((fixture) => {
            InvoiceEndpoints.view(billRunId, invoiceId).then((response) => {
              expect(response.status).to.be.equal(200)
              expect(response.body.invoice.billRunId).to.equal(billRunId)
              expect(response.body.invoice.ruleset).to.equal(ruleset)
              expect(response.body.invoice.customerReference).to.equal(fixture.customerReference)
              expect(response.body.invoice.financialYear).to.equal(2021)
  
              if (invoiceType === 'debit') {
                  expect(response.body.invoice.creditLineValue).to.equal(0)
                  expect(response.body.invoice.debitLineValue).to.equal(10000)
                  expect(response.body.invoice.netTotal).to.equal(10000)   
              } else if (invoiceType === 'credit') {
                  expect(response.body.invoice.creditLineValue).to.equal(10000)
                  expect(response.body.invoice.debitLineValue).to.equal(0)
                  expect(response.body.invoice.netTotal).to.equal(-10000) 
              } else if (invoiceType === 'deminimis') {
                  expect(response.body.invoice.deminimisInvoice).to.equal(true)
                  expect(response.body.invoice.creditLineValue).to.equal(0)
                  expect(response.body.invoice.debitLineValue).to.equal(800)
                  expect(response.body.invoice.netTotal).to.equal(800) 
              } else if (invoiceType === 'minimumCharge') {
                  expect(response.body.invoice.minimumChargeInvoice).to.equal(true)
                  expect(response.body.invoice.creditLineValue).to.equal(0)
                  expect(response.body.invoice.debitLineValue).to.equal(2500)
                  expect(response.body.invoice.netTotal).to.equal(2500)
              } else {
                  expect(response.body.invoice.zeroValueInvoice).to.equal(true)
                  expect(response.body.invoice.creditLineValue).to.equal(800)
                  expect(response.body.invoice.debitLineValue).to.equal(800)
                  expect(response.body.invoice.netTotal).to.equal(0) 
              }
  
              expect(response.body.invoice.transactionReference).to.equal(null)
              expect(response.body.invoice.rebilledType).to.equal('O')
              expect(response.body.invoice.rebilledInvoiceId).to.equal('99999999-9999-9999-9999-999999999999')
            })
          })
        })
      })
    })
  })