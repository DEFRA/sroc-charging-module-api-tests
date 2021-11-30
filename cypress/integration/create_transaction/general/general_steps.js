import { Then, And } from 'cypress-cucumber-preprocessor/steps'
import TransactionEndpoints from '../../../endpoints/transaction_endpoints'

And('I add a {word} {word} transaction to it', (transactionType, ruleset) => {
  const fixtureName = `${transactionType}.${ruleset}.transaction`
  const clientID = crypto.randomUUID()

  cy.fixture(fixtureName).then((fixture) => {
    fixture.clientId = clientID
    cy.get('@billRun').then((billRun) => {
      TransactionEndpoints.create(billRun.id, fixture, false).then((response) => {
        cy.wrap(response).as('transaction')
      })
    })
  })
})

And('I add 2 standard {word} transactions to it with the same client IDs', (ruleset) => {
  const fixtureName = `standard.${ruleset}.transaction`
  const clientID = crypto.randomUUID()

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

And('I add an invalid {word} transaction to it', (ruleset) => {
  const fixtureName = `standard.${ruleset}.transaction`

  cy.log(`Sending invalid '${ruleset}' transaction request`)

  cy.fixture(fixtureName).then((fixture) => {
    fixture.periodStart = ' '
    cy.get('@billRun').then((billRun) => {
      TransactionEndpoints.create(billRun.id, fixture, false).then((response) => {
        cy.wrap(response).as('transaction')
      })
    })
  })
})

Then('I get a successful response', () => {
  cy.log('Testing valid transaction')

  cy.get('@transaction').then((response) => {
    expect(response.status).to.equal(201)
    expect(response.body).to.have.property('transaction')
    expect(response.body.transaction.id).not.to.equal(null)
    expect(response.body.transaction.clientId).not.to.equal(null)
  })
})

Then('I get a failed response', () => {
  cy.log('Testing invalid transaction')

  cy.get('@transaction').then((response) => {
    expect(response.status).to.equal(422)
    expect(response.body).to.have.property('error')
  })
})
