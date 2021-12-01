import { When, Then } from 'cypress-cucumber-preprocessor/steps'
import CalculateChargeEndpoints from '../../../endpoints/calculate_charge_endpoints'

When('I make a valid {word} request', (ruleset) => {
  const fixtureName = `calculate.${ruleset}.charge`

  cy.fixture(fixtureName).then((calculateCharge) => {
    CalculateChargeEndpoints.calculate(calculateCharge).then((response) => {
      cy.wrap(response).as('calculateChargeResponse')
    })
  })
})

Then('I get a successful presroc response', () => {
  const expectedResult = {
    calculation: {
      chargeValue: 2093,
      sourceFactor: 3,
      seasonFactor: 1.6,
      lossFactor: 0.03,
      licenceHolderChargeAgreement: null,
      chargeElementAgreement: null,
      eiucSourceFactor: 0,
      eiuc: 0,
      suc: 2751
    }
  }

  cy.get('@calculateChargeResponse').then((response) => {
    expect(response.status).to.equal(200)
    expect(response.body).to.have.property('calculation')

    expect(JSON.stringify(response.body)).to.equal(JSON.stringify(expectedResult))
  })
})

Then('I get a successful sroc response', () => {
  const expectedResult = {
    calculation: {
      chargeValue: 9481,
      baseCharge: 9700,
      waterCompanyChargeValue: 0,
      supportedSourceValue: 0,
      winterOnlyFactor: null,
      section130Factor: null,
      section127Factor: null,
      compensationChargePercent: null
    }
  }

  cy.get('@calculateChargeResponse').then((response) => {
    expect(response.status).to.equal(200)
    expect(response.body).to.have.property('calculation')

    expect(JSON.stringify(response.body)).to.equal(JSON.stringify(expectedResult))
  })
})

When('I make an invalid {word} request', (ruleset) => {
  const fixtureName = `calculate.${ruleset}.charge`

  cy.fixture(fixtureName).then((calculateCharge) => {
    calculateCharge.periodEnd = ''
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
