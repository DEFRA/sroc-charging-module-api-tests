import { When, Then } from 'cypress-cucumber-preprocessor/steps'
import CalculateChargeEndpoints from '../../../endpoints/calculate_charge_endpoints'

When('the ruleset is set to {word}', (ruleset) => {
  const fixtureName = ruleset === 'cors' ? 'calculate.sroc.charge' : `calculate.${ruleset}.charge`

  cy.fixture(fixtureName).then((fixture) => {
    fixture.ruleset = ruleset
    cy.wrap(fixture).as('calculateChargeRequest')
  })
})

Then('I get a {int} response', (status) => {
  cy.get('@calculateChargeRequest').then((request) => {
    const failOnStatusCode = status === 200

    CalculateChargeEndpoints.calculate(request, failOnStatusCode).then((response) => {
      expect(response.status).to.equal(status)
    })
  })
})
