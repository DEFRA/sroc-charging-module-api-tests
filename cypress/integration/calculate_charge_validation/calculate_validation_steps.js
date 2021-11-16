import { When, Then } from 'cypress-cucumber-preprocessor/steps'
import TransactionEndpoints from '../../endpoints/transaction_endpoints'

function invalid (ruleSet, dataItems) {
  cy.fixture(`calculate.${ruleSet}.charge`).then((calculateCharge) => {
    calculateCharge.ruleset = ruleSet
    dataItems.forEach(item => {
      calculateCharge[item.key] = item.value
    })

    TransactionEndpoints.calculateInvalid(calculateCharge).then((response) => {
      expect(response.status).to.equal(422)
      cy.wrap(response.body).as('calculateChargeResponse')
    })
  })
}

function valid (ruleSet, dataItems) {
  cy.fixture(`calculate.${ruleSet}.charge`).then((calculateCharge) => {
    calculateCharge.ruleset = ruleSet
    dataItems.forEach(item => {
      calculateCharge[item.key] = item.value
    })

    TransactionEndpoints.calculate(calculateCharge).then((response) => {
      expect(response.status).to.equal(200)
      cy.wrap(response.body).as('calculateChargeResponse')
    })
  })
}

When('I calculate an invalid {word} charge with {word} as {string}', (ruleSet, dataItem, value) => {
  const dataItems = [{ key: dataItem, value: value }]
  invalid(ruleSet, dataItems)
})

When('I calculate an invalid {word} charge with {word} as {float}', (ruleSet, dataItem, value) => {
  const dataItems = [{ key: dataItem, value: value }]
  invalid(ruleSet, dataItems)
})

When('I calculate an invalid {word} charge with {word} as {int}', (ruleSet, dataItem, value) => {
  const dataItems = [{ key: dataItem, value: value }]
  invalid(ruleSet, dataItems)
})

When('I calculate a valid {word} charge with {word} as {string}', (ruleSet, dataItem, value) => {
  const dataItems = [{ key: dataItem, value: value }]
  valid(ruleSet, dataItems)
})

When('I calculate a valid {word} charge with {word} as {float}', (ruleSet, dataItem, value) => {
  const dataItems = [{ key: dataItem, value: value }]
  valid(ruleSet, dataItems)
})

When('I calculate a valid {word} charge with {word} as {int}', (ruleSet, dataItem, value) => {
  const dataItems = [{ key: dataItem, value: value }]
  valid(ruleSet, dataItems)
})

When('I calculate a valid {word} charge with {word} as {word}', (ruleSet, dataItem, value) => {
  const dataItems = [{ key: dataItem, value: value }]
  valid(ruleSet, dataItems)
})

When('I calculate an invalid {word} charge with {word} as {string} and {word} as {string}', (ruleSet, dataItem1, value, dataItem, value1) => {
  const dataItems = [{ key: dataItem1, value: value }, { key: dataItem, value: value1 }]
  invalid(ruleSet, dataItems)
})

When('I calculate an invalid {word} charge with {word} as {float} and {word} as {float}', (ruleSet, dataItem1, value, dataItem, value1) => {
  const dataItems = [{ key: dataItem1, value: value }, { key: dataItem, value: value1 }]
  invalid(ruleSet, dataItems)
})

When('I calculate an invalid {word} charge with {word} as {int} and {word} as {int}', (ruleSet, dataItem1, value, dataItem, value1) => {
  const dataItems = [{ key: dataItem1, value: value }, { key: dataItem, value: value1 }]
  invalid(ruleSet, dataItems)
})

When('I calculate an invalid {word} charge with {word} as {word} and {word} as {word}', (ruleSet, dataItem1, value, dataItem, value1) => {
  const dataItems = [{ key: dataItem1, value: value }, { key: dataItem, value: value1 }]
  invalid(ruleSet, dataItems)
})

When('I calculate an invalid {word} charge with {word} as {word} and {word} as {string}', (ruleSet, dataItem1, value, dataItem, value1) => {
  const dataItems = [{ key: dataItem1, value: value }, { key: dataItem, value: value1 }]
  invalid(ruleSet, dataItems)
})

When('I calculate an invalid {word} charge with {word} as {word} and {word} as {float}', (ruleSet, dataItem1, value, dataItem, value1) => {
  const dataItems = [{ key: dataItem1, value: value }, { key: dataItem, value: value1 }]
  invalid(ruleSet, dataItems)
})

When('I calculate an invalid {word} charge with {word} as {word} and {word} as {int}', (ruleSet, dataItem1, value, dataItem, value1) => {
  const dataItems = [{ key: dataItem1, value: value }, { key: dataItem, value: value1 }]
  invalid(ruleSet, dataItems)
})

When('I calculate an invalid {word} charge with {word} as {string} and {word} as {word}', (ruleSet, dataItem1, value, dataItem, value1) => {
  const dataItems = [{ key: dataItem1, value: value }, { key: dataItem, value: value1 }]
  invalid(ruleSet, dataItems)
})

When('I calculate a valid {word} charge with {word} as {string} and {word} as {string}', (ruleSet, dataItem1, value, dataItem, value1) => {
  const dataItems = [{ key: dataItem1, value: value }, { key: dataItem, value: value1 }]
  valid(ruleSet, dataItems)
})

When('I calculate a valid {word} charge with {word} as {float} and {word} as {float}', (ruleSet, dataItem1, value, dataItem, value1) => {
  const dataItems = [{ key: dataItem1, value: value }, { key: dataItem, value: value1 }]
  valid(ruleSet, dataItems)
})

When('I calculate a valid {word} charge with {word} as {int} and {word} as {int}', (ruleSet, dataItem1, value, dataItem, value1) => {
  const dataItems = [{ key: dataItem1, value: value }, { key: dataItem, value: value1 }]
  valid(ruleSet, dataItems)
})

Then('I am told that a valid ruleset is required', () => {
  cy.get('@calculateChargeResponse').then((error) => {
    expect(error.message).to.equal('Invalid ruleset')
  })
})

Then('I am told that {word} is required', (dataItem) => {
  cy.get('@calculateChargeResponse').then((error) => {
    expect(error.message).to.equal('"' + dataItem + '" is required')
  })
})

Then('I am told that periodEnd is required with information about date requirements', () => {
  cy.get('@calculateChargeResponse').then((error) => {
    expect(error.message).to.equal('"periodEnd" is required. "periodStart" date references "ref:periodEnd" which must have a valid date format')
  })
})

Then('{int} is returned for {word} in the response', (value1, responseDataItem) => {
  cy.get('@calculateChargeResponse').then((response) => {
    expect(response[responseDataItem]).to.equal(value1)
  })
})

Then('I am told the {word} must be a {word}', (dataItem, value1) => {
  cy.get('@calculateChargeResponse').then((error) => {
    expect(error.message).to.equal('"' + dataItem + '" must be a ' + value1)
  })
})

Then('I am told the {word} must be an {word}', (dataItem, value1) => {
  cy.get('@calculateChargeResponse').then((error) => {
    expect(error.message).to.equal('"' + dataItem + '" must be an ' + value1)
  })
})

Then('I am told the {word} must be {word}', (dataItem, value1) => {
  cy.get('@calculateChargeResponse').then((error) => {
    expect(error.message).to.equal('"' + dataItem + '" must be an ' + value1)
  })
})

Then('I am told that the {word} financial year must be {int}', (dataItem1, value2) => {
  cy.get('@calculateChargeResponse').then((error) => {
    expect(error.message).to.equal('"' + dataItem1 + 'FinancialYear" must be [' + value2 + ']')
  })
})

Then('I am told that the {word} must be {word} than or equal to {word}', (dataItem1, value2, dataItem) => {
  cy.get('@calculateChargeResponse').then((error) => {
    expect(error.message).to.equal('"' + dataItem1 + '" must be ' + value2 + ' than or equal to "ref:' + dataItem + '"')
  })
})

Then('I am told that the {word} date must be {word} than or equal to {word}', (dataItem1, value2, dataItem) => {
  cy.get('@calculateChargeResponse').then((error) => {
    expect(error.message).to.equal('"' + dataItem1 + '" must be ' + value2 + ' than or equal to "' + dataItem + '"')
  })
})

Then('I am told that the {word} number must be {word} than or equal to {word}', (dataItem, value1, value2) => {
  cy.get('@calculateChargeResponse').then((error) => {
    expect(error.message).to.equal('"' + dataItem + '" must be ' + value1 + ' than or equal to ' + value2)
  })
})

Then('I am told that the {word} number must be {word} than {word}', (dataItem, value1, value2) => {
  cy.get('@calculateChargeResponse').then((error) => {
    expect(error.message).to.equal('"' + dataItem + '" must be ' + value1 + ' than ' + value2)
  })
})

Then('a charge is calculated', () => {
  cy.get('@calculateChargeResponse').then((response) => {
    expect(response.chargeValue).to.not.equal(null)
  })
})
