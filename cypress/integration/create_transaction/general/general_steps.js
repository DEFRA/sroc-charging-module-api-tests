import { Then, And } from 'cypress-cucumber-preprocessor/steps'
import TransactionEndpoints from '../../../endpoints/transaction_endpoints'

And('I add 2 standard {word} transactions to it with the same client IDs', (ruleset) => {
  const fixtureName = `standard.${ruleset}.transaction`
  const uuid = require('uuid')

  const clientID = uuid.v4()

  cy.log(`Sending invalid '${ruleset}' transaction request`)

  cy.fixture(fixtureName).then((fixture) => {
    fixture.clientId = clientID
    cy.get('@billRun').then((billRun) => {
      TransactionEndpoints.create(billRun.id, fixture, false).then((response) => {
        cy.wrap(response).as('transaction1')
      })
      TransactionEndpoints.create(billRun.id, fixture, false).then((response) => {
        cy.wrap(response).as('transaction2')
      })
    })
  })
})

Then('I am told that the client ID must be unique', () => {
  cy.get('@transaction1').then((response) => {
    expect(response.status).to.equal(201)
    expect(response.body).to.have.property('transaction')
  })
  cy.get('@transaction2').then((response) => {
    expect(response.status).to.equal(409)
    expect(response.body).to.have.property('error')
  })
})
