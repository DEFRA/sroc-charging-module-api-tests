import { When, Then } from 'cypress-cucumber-preprocessor/steps'
import CalculateChargeEndpoints from '../../../endpoints/calculate_charge_endpoints'

When('I make a valid {word} {word} request', (ruleset, type) => {
  const fixtureName = `calculate.${ruleset}.charge`

  cy.fixture(fixtureName).then((calculateCharge) => {
    calculateCharge.credit = (type === 'credit')

    CalculateChargeEndpoints.calculate(calculateCharge).then((response) => {
      cy.wrap(response).as('calculateChargeResponse')
    })
  })
})

Then('I get a successful presroc {word} response', (type) => {
  const chargeValue = (type === 'credit') ? -2093 : 2093
  const expectedResult = {
    calculation: {
      chargeValue,
      sourceFactor: 3,
      seasonFactor: 1.6,
      lossFactor: 0.03,
      section130Factor: null,
      section127Factor: null,
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

Then('I get a successful sroc {word} response', (type) => {
  const chargeValue = (type === 'credit') ? -9481 : 9481
  const expectedResult = {
    calculation: {
      chargeValue,
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

When('I make a valid presroc request with section127Agreement set to true', (ruleset) => {
  const fixtureName = 'calculate.presroc.charge'

  cy.fixture(fixtureName).then((calculateCharge) => {
    calculateCharge.section127Agreement = true

    CalculateChargeEndpoints.calculate(calculateCharge).then((response) => {
      cy.wrap(response).as('calculateChargeResponse')
    })
  })
})

Then('I get a successful response that includes chargeElementAgreement populated', () => {
  cy.get('@calculateChargeResponse').then((response) => {
    expect(response.status).to.equal(200)
    expect(response.body).to.have.property('calculation')
    expect(response.body.calculation.chargeElementAgreement).to.equal('S127 x 0.5')
  })
})
