import { Then } from 'cypress-cucumber-preprocessor/steps'
import BillRunEndpoints from '../../../endpoints/bill_run_endpoints'

Then('I request to view the bill run with an unknown bill run id I am told that bill run id is unknown', () => {
  const uuid = require('uuid')
  const billRunId = uuid.v4()

  BillRunEndpoints.view(billRunId, false).then((response) => {
    expect(response.status).to.be.equal(404)
    expect(response.body).to.have.property('error')
    expect(response.body.message).to.equal(`Bill run ${billRunId} is unknown.`)
  })
})

Then('I request to generate the bill run with an unknown bill run id I am told that bill run id is unknown', () => {
  const uuid = require('uuid')
  const billRunId = uuid.v4()

  BillRunEndpoints.generate(billRunId, false).then((response) => {
    expect(response.status).to.be.equal(404)
    expect(response.body).to.have.property('error')
    expect(response.body.message).to.equal(`Bill run ${billRunId} is unknown.`)
  })
})

Then('I request to generate the bill run I am told that Bill run cannot be generated without any transactions', () => {
  cy.get('@billRun').then((billRun) => {
    BillRunEndpoints.generate(billRun.id, false).then((response) => {
      expect(response.status).to.be.equal(422)
      expect(response.body).to.have.property('error')
      expect(response.body.message).to.equal(`Summary for bill run ${billRun.id} cannot be generated because it has no transactions.`)
    })
  })
})
