import { And } from 'cypress-cucumber-preprocessor/steps'
import BillRunEndpoints from '../../endpoints/bill_run_endpoints'
import LicenceEndpoints from '../../endpoints/licence_endpoints'

And('I request to delete the licence {word} for {word}', (licenceNum, customerRef) => {
  cy.get('@billRun').then((billRun) => {
    const billRunId = billRun.id

    BillRunEndpoints.view(billRunId).then((response) => {
      expect(response.status).to.be.equal(200)
      cy.wrap(response.body.billRun).as('viewBillRun')

      cy.get('@viewBillRun').then((viewBillRun) => {
        const invoice = viewBillRun.invoices.find(element => element.customerReference === customerRef)
        const licence = invoice.licences.find(element => element.licenceNumber === licenceNum)
        const licenceId = licence.id

        LicenceEndpoints.delete(billRunId, licenceId).then((response) => {
          expect(response.status).to.be.equal(204)
        })
      })
    })
  })
})

And('invoice {word} is no longer listed under the bill run', (customerRef) => {
  cy.get('@viewBillRun').then((viewBillRun) => {
    const invoices = viewBillRun.invoices
    expect(JSON.stringify(invoices)).to.not.include(customerRef)
  })
})

And('licence {word} is no longer listed under invoice {word}', (licenceNum, customerRef) => {
  cy.get('@viewBillRun').then((viewBillRun) => {
    const invoice = viewBillRun.invoices.find(element => element.customerReference === customerRef)
    const licence = invoice.licences
    expect(licence).to.not.include(licenceNum)
  })
})
