import { Then, And } from 'cypress-cucumber-preprocessor/steps'
import LicenceEndpoints from '../../../endpoints/licence_endpoints'
import BillRunEndpoints from '../../../endpoints/bill_run_endpoints'

Then('I request to delete the licence with an unknown licence ID and I am told its unknown', () => {
  cy.get('@billRun').then((billRun) => {
    const billRunId = billRun.id

    const uuid = require('uuid')
    const licenceId = uuid.v4()

    LicenceEndpoints.delete(billRunId, licenceId, false).then((response) => {
      expect(response.status).to.be.equal(404)
      expect(response.body.message).to.be.equal(`Licence ${licenceId} is unknown.`)
    })
  })
})

And('I request to delete the licence {word} for {word} and I am told its not linked to this bill run', (licenceNum, customerRef) => {
  cy.get('@billRun').then((billRun) => {
    const billRunId = billRun.id
    cy.get('@billRun1').then((billRun1) => {
      const billRunId1 = billRun1.id

      BillRunEndpoints.view(billRunId).then((response) => {
        expect(response.status).to.be.equal(200)
        cy.wrap(response.body.billRun).as('viewBillRun')

        cy.get('@viewBillRun').then((viewBillRun) => {
          const invoice = viewBillRun.invoices.find(element => element.customerReference === customerRef)
          const licence = invoice.licences.find(element => element.licenceNumber === licenceNum)
          const licenceId = licence.id
          LicenceEndpoints.delete(billRunId1, licenceId, false).then((response) => {
            expect(response.status).to.be.equal(409)
            expect(response.body.message).to.be.equal(`Licence ${licenceId} is not linked to bill run ${billRunId1}.`)
          })
        })
      })
    })
  })
})

Then('I request to delete the licence {word} for {word} and I am told the bill run cannot be edited because its status is {word}', (licenceNum, customerRef, billRunStatus) => {
  cy.get('@billRun').then((billRun) => {
    const billRunId = billRun.id

    BillRunEndpoints.view(billRunId).then((response) => {
      expect(response.status).to.be.equal(200)
      cy.wrap(response.body.billRun).as('viewBillRun')

      cy.get('@viewBillRun').then((viewBillRun) => {
        const invoice = viewBillRun.invoices.find(element => element.customerReference === customerRef)
        const licence = invoice.licences.find(element => element.licenceNumber === licenceNum)
        const licenceId = licence.id

        LicenceEndpoints.delete(billRunId, licenceId, false).then((response) => {
          expect(response.status).to.be.equal(409)
          expect(response.body.message).to.be.equal(`Bill run ${billRunId} cannot be edited because its status is ${billRunStatus}.`)
        })
      })
    })
  })
})
