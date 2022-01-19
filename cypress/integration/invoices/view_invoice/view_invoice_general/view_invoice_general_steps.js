import { Then, And } from 'cypress-cucumber-preprocessor/steps'
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
            cy.wrap(response.body).as('viewInvoice')
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
            } else if (ruleset === 'sroc' && invoiceType === 'deminimis') {
              expect(response.body.invoice.deminimisInvoice).to.equal(true)
              expect(response.body.invoice.creditLineValue).to.equal(0)
              expect(response.body.invoice.debitLineValue).to.equal(800)
              expect(response.body.invoice.netTotal).to.equal(800)
            } else if (ruleset === 'presroc' && invoiceType === 'deminimis') {
              expect(response.body.invoice.deminimisInvoice).to.equal(true)
              expect(response.body.invoice.creditLineValue).to.equal(0)
              expect(response.body.invoice.debitLineValue).to.equal(300)
              expect(response.body.invoice.netTotal).to.equal(300)
            } else if (invoiceType === 'minimumCharge') {
              // const minCharge = 2500
              // const chargeDifference = minCharge - charge
              // const chargeValue = chargeDifference + charge
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

And('the licence level items are correct', () => {
  cy.log('Checking licence level items')

  cy.get('@viewInvoice').then((viewInvoice) => {
    const licence = viewInvoice.invoice.licences[0]

    cy.get('@fixture').then((fixture) => {
      expect(licence.licenceNumber).to.equal(fixture.licenceNumber)
    })
  })
})

And('the transaction level items are correct', () => {
  cy.log('Checking transaction level items')
  cy.get('@rulesetType').then((rulesetType) => {
    const ruleset = rulesetType
    cy.get('@viewInvoice').then((viewInvoice) => {
      const licence = viewInvoice.invoice.licences[0]
      const transaction = licence.transactions[0]

      cy.get('@fixture').then((fixture) => {
        // expect(transaction.clientId).to.equal(fixture.clientId)
        expect(transaction.credit).to.equal(fixture.credit)
        expect(transaction.lineDescription).to.equal(fixture.lineDescription)
        expect(transaction.compensationCharge).to.equal(fixture.compensationCharge)

        if (ruleset === 'presroc') {
          const charge = fixture.section126Factor * 1000
          expect(transaction.chargeValue).to.equal(charge)
        } else {
          const charge = fixture.abatementFactor * 1000
          expect(transaction.chargeValue).to.equal(charge)
        }
      })
    })
  })
})
