import { When, Then } from 'cypress-cucumber-preprocessor/steps'
import CalculateChargeEndpoints from '../../../endpoints/calculate_charge_endpoints'

When('I make a valid request', () => {
  cy.fixture('calculate.presroc.charge').then((calculateCharge) => {
    CalculateChargeEndpoints.calculate(calculateCharge).then((response) => {
      cy.wrap(response).as('calculateChargeResponse')
    })
  })
})

Then('I get a successful response', () => {
  cy.get('@calculateChargeResponse').then((response) => {
    expect(response.status).to.equal(200)
    expect(response.body).to.have.property('calculation')
  })
})

When('I make an invalid request', () => {
  cy.fixture('calculate.presroc.charge').then((calculateCharge) => {
    calculateCharge.ruleset = 'cors'
    CalculateChargeEndpoints.calculate(calculateCharge, false).then((response) => {
      cy.wrap(response).as('calculateChargeResponse')
    })
  })
})

Then('I get a failed response', () => {
  cy.get('@calculateChargeResponse').then((response) => {
    expect(response.status).to.equal(422)
    expect(response.body).to.have.property('error')
  })
})
