import { Then } from 'cypress-cucumber-preprocessor/steps'

Then('the transaction reference is the correct format for {word}', (customerRef) => {
  cy.log('Checking transaction reference is correct format')
  cy.get('@viewBillRun').then((billRun) => {
    const region = billRun.region
    // Capture transaction reference at view bill run
    const invoice = billRun.invoices.find(element => element.customerReference === customerRef)
    const transactionRefVBR = invoice.transactionReference

    cy.get('@rulesetType').then((rulesetType) => {
      const ruleset = rulesetType
      cy.get('@invoice').then((invoice) => {
        const transactionRefVI = invoice.transactionReference
        const netTotal = invoice.netTotal

        if (invoice.zeroValueInvoice === true || invoice.deminimisInvoice === true) {
          expect(transactionRefVI).to.equal(null)
        } else if (netTotal !== 0) {
          const regionIndicator = transactionRefVI.slice(0, 1)
          const fixedCharA = transactionRefVI.slice(1, 2)
          const transactionType = transactionRefVI.slice(2, 3)
          const refNumber = transactionRefVI.slice(3, 10)

          expect(regionIndicator).to.equal(region)

          if (netTotal < 0) {
            expect(transactionType).to.equal('C')
          } else if (netTotal > 0) {
            expect(transactionType).to.equal('I')
          }
          expect(fixedCharA).to.equal('A')
          expect(refNumber).to.have.length(7)

          if (ruleset === 'sroc') {
            const fixedCharT = transactionRefVI.slice(-1)
            expect(transactionRefVI).to.have.length(11)
            expect(fixedCharT).to.equal('T')
          } else {
            expect(transactionRefVI).to.have.length(10)
          }
          expect(transactionRefVBR).to.equal(transactionRefVI)
        }
      })
    })
  })
})
