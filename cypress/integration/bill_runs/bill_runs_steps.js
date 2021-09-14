import { When, Then } from 'cypress-cucumber-preprocessor/steps'
import BillRunEndpoints from '../../endpoints/bill_run_endpoints'
import TransactionEndpoints from '../../endpoints/transaction_endpoints'

When('I request a new bill run', () => {
  BillRunEndpoints.create({ region: 'A' }).then((response) => {
    expect(response.status).to.equal(201)
    cy.wrap(response.body.billRun).as('billRun')
  })
})

Then('the bill run ID and number are returned', () => {
  cy.get('@billRun').then((billRun) => {
    expect(billRun.id).not.to.equal(null)
    expect(billRun.billRunNumber).not.to.equal(null)
  })
})

When('I request to view a bill run', () => {
  BillRunEndpoints.create({ region: 'A' }).then((response) => {
    expect(response.status).to.equal(201)
    cy.wrap(response.body.billRun).as('billRun')
  })
})

Then('details of the bill run are returned', () => {
  cy.get('@billRun').then((billRun) => {
    BillRunEndpoints.view(billRun.id).then((response) => {
      expect(response.status).to.equal(200)

      expect(response.body).to.have.property('billRun')

      expect(response.body.billRun.id).to.equal(billRun.id)
      expect(response.body.billRun.billRunNumber).to.equal(billRun.billRunNumber)

      expect(response.body.billRun.region).to.equal('A')
      expect(response.body.billRun.status).to.equal('initialised')
    })
  })
})

When('I request to generate a bill run', () => {
  BillRunEndpoints.create({ region: 'A' }).its('body.billRun.id').as('billRunId')

  cy.fixture('standard.transaction').then((transaction) => {
    transaction.customerReference = 'TH230000222'
    transaction.licenceNumber = 'TONY/TF9222/38'

    cy.get('@billRunId').then((billRunId) => {
      TransactionEndpoints.create(billRunId, transaction)
    })
  })
  cy.get('@billRunId').then((billRunId) => {
    BillRunEndpoints.generate(billRunId).then((response) => {
      expect(response.status).to.be.equal(204)
    })
  })
})

Then('bill run status is updated to {string}', (status) => {
  cy.get('@billRunId').then((billRunId) => {
    BillRunEndpoints.pollForStatus(billRunId, status).then((response) => {
      expect(response.status).to.equal(200)
      expect(response.body.status).to.equal(status)
    })
  })
})
