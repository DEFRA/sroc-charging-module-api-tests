import { Then, When } from 'cypress-cucumber-preprocessor/steps'
import BillRunEndpoints from '../../../endpoints/bill_run_endpoints'
import TransactionEndpoints from '../../../endpoints/transaction_endpoints'

When('I do not send the following values I get the expected response', (dataTable) => {
    cy.wrap(dataTable.rawTable).each(row => {
      const ruleset = row[0]
      const property = row[1]
      const fixtureName = `standard.${ruleset}.transaction`
  
      cy.log(`Testing ruleset '${ruleset}' and property '${property}'`)
  
      cy.fixture(fixtureName).then((fixture) => {
          fixture[property] = ''

      cy.get('@billRun').then((billRun) => {
        TransactionEndpoints.create(billRun.id, fixture, false).then((response) => {
          expect(response.status).to.equal(422)
          })
        })
      })
    })
  })

And('I send a {word} request where {word} is true', (ruleset, property) => {
    const fixtureName = `standard.${ruleset}.transaction`

    cy
      .fixture(fixtureName).then((fixture) => {
        fixture[property] = true
      })
      .as('createTransactionRequest')
  })

Then('If I do not send the following values I get the expected response', (dataTable) => {
    cy.wrap(dataTable.rawTable).each(row => {
      const property = row[0]
  
      cy.get('@createTransactionRequest').then((request) => {
        request[property] = ''
        cy.log(`Testing property '${property}'`)

      cy.get('@billRun').then((billRun) => {
        TransactionEndpoints.create(billRun.id, request, false).then((response) => {
          expect(response.status).to.equal(422)
          })
        })
      })
    })
  })