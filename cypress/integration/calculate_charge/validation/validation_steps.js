import { Then, When } from 'cypress-cucumber-preprocessor/steps'
import CalculateChargeEndpoints from '../../../endpoints/calculate_charge_endpoints'

When('I use the following ruleset values I get the expected response', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    cy.log(`Testing ruleset '${row[0]}'. Expect ${row[1]} response`)

    const fixtureName = row[0] === 'cors' ? 'calculate.sroc.charge' : `calculate.${row[0]}.charge`

    cy.fixture(fixtureName).then((fixture) => {
      fixture.ruleset = row[0]

      const failOnStatusCode = row[1] === 200

      CalculateChargeEndpoints.calculate(fixture, failOnStatusCode).then((response) => {
        expect(response.status.toString()).to.equal(row[1])
      })
    })
  })
})

When('I do not send the following values I get the expected response', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const ruleset = row[0]
    const property = row[1]
    const fixtureName = `calculate.${ruleset}.charge`

    cy.log(`Testing ruleset '${ruleset}' and property '${property}'`)

    cy.fixture(fixtureName).then((fixture) => {
      // This allows us to both set the appropriate ruleset for each request and verify that ruleset is a mandatory
      // field
      if (property === 'ruleset') {
        fixture.ruleset = ''
      } else {
        fixture.ruleset = ruleset
        fixture[property] = ''
      }

      CalculateChargeEndpoints.calculate(fixture, false).then((response) => {
        expect(response.status).to.equal(422)
      })
    })
  })
})

When('I send a {word} request where {word} is true', (ruleset, property) => {
  const fixtureName = `calculate.${ruleset}.charge`

  cy
    .fixture(fixtureName).then((fixture) => {
      fixture[property] = true
    })
    .as('calculateChargeRequest')
})

Then('If I do not send the following values I get the expected response', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const property = row[0]

    cy.get('@calculateChargeRequest').then((request) => {
      const requestClone = { ...request }
      cy.log(`Testing ruleset '${request.ruleset}' and property '${property}'`)

      requestClone[property] = ''

      CalculateChargeEndpoints.calculate(requestClone, false).then((response) => {
        expect(response.status).to.equal(422)
      })
    })
  })
})
