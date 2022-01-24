import { Then } from 'cypress-cucumber-preprocessor/steps'

Then('the transaction file reference is generated', () => {
  cy.log('Checking transaction file reference is generated')
  cy.get('@viewBillRun').then((billRun) => {
    expect(billRun.transactionFileReference).to.not.equal(null)
  })
})

Then('the transaction file reference is the correct format', () => {
  cy.log('Checking transaction reference is correct format')
  cy.get('@viewBillRun').then((billRun) => {
    cy.get('@rulesetType').then((rulesetType) => {
      const ruleset = rulesetType
      const transactionFileRefString = billRun.transactionFileReference

      if (billRun.status === 'billing_not_required') {
        expect(transactionFileRefString).to.equal(null)
      } else if (billRun.status === 'billed') {
        const NAL = transactionFileRefString.slice(0, 3)
        const regionIndicator = transactionFileRefString.slice(3, 4)
        const invoiceFile = transactionFileRefString.slice(4, 5)
        const refNumber = transactionFileRefString.slice(5, 10)

        const region = billRun.region

        expect(NAL).to.equal('nal')
        expect(regionIndicator).to.equal(region.toLowerCase())
        expect(invoiceFile).to.equal('i')
        expect(refNumber).to.have.length(5)

        if (ruleset === 'sroc') {
          const fixedCharT = transactionFileRefString.slice(-1)
          expect(transactionFileRefString).to.have.length(11)
          expect(fixedCharT).to.equal('t')
        } else {
          expect(transactionFileRefString).to.have.length(10)
        }
      }
    })
  })
})
