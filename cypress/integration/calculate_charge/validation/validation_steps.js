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

When('I do not send the following values the CM sets the correct default', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const ruleset = row[0]
    const requestProperty = row[1]
    const responseProperty = row[2]
    const expectedValue = row[3]

    const fixtureName = `calculate.${ruleset}.charge`

    cy.log(`Testing '${ruleset}' property '${requestProperty}' comes back as '${responseProperty} = ${expectedValue}'`)

    cy.fixture(fixtureName).then((fixture) => {
      fixture[requestProperty] = ''

      CalculateChargeEndpoints.calculate(fixture).then((response) => {
        expect(response.status).to.equal(200)
        expect(response[responseProperty]).to.equal(expectedValue)
      })
    })
  })
})

When('I send the following properties with the wrong data types I am told what they should be', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const ruleset = row[0]
    const property = row[1]
    const correctDataType = row[2]
    const fixtureName = `calculate.${ruleset}.charge`

    cy.log(`Testing '${ruleset}' property '${property}' should be a ${correctDataType}`)

    cy.fixture(fixtureName).then((fixture) => {
      fixture.ruleset = ruleset
      fixture[property] = 'crazy'

      CalculateChargeEndpoints.calculate(fixture, false).then((response) => {
        expect(response.status).to.equal(422)
        expect(response.body.message).to.contain(`"${property}" must be a ${correctDataType}`)
      })
    })
  })
})

When('I send the following period start and end dates I am told what financial year periodEnd must be', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const ruleset = row[0]
    const periodStart = row[1]
    const periodEnd = row[2]
    const financialYear = row[3]
    const fixtureName = `calculate.${ruleset}.charge`

    cy.log(`Testing '${ruleset}' when period is ${periodStart}-${periodEnd} periodEnd year should be ${financialYear}`)

    cy.fixture(fixtureName).then((fixture) => {
      fixture.ruleset = ruleset
      fixture.periodStart = periodStart
      fixture.periodEnd = periodEnd

      CalculateChargeEndpoints.calculate(fixture, false).then((response) => {
        expect(response.status).to.equal(422)
        expect(response.body.message).to.equal(`"periodEndFinancialYear" must be [${financialYear}]`)
      })
    })
  })
})

When(
  'I send the following period dates I am told that periodStart must be less than or equal to periodEnd',
  (dataTable) => {
    cy.wrap(dataTable.rawTable).each(row => {
      const ruleset = row[0]
      const periodStart = row[1]
      const periodEnd = row[2]
      const fixtureName = `calculate.${ruleset}.charge`

      cy.log(`Testing '${ruleset}' when period is ${periodStart}-${periodEnd} periodStart is invalid`)

      cy.fixture(fixtureName).then((fixture) => {
        fixture.ruleset = ruleset
        fixture.periodStart = periodStart
        fixture.periodEnd = periodEnd

        CalculateChargeEndpoints.calculate(fixture, false).then((response) => {
          expect(response.status).to.equal(422)
          expect(response.body.message).to.equal('"periodStart" must be less than or equal to "ref:periodEnd"')
        })
      })
    })
  })

When('I send the following period dates I am told that periodStart is before the ruleset start date', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const ruleset = row[0]
    const periodStart = row[1]
    const periodEnd = row[2]
    const startDate = row[3]
    const fixtureName = `calculate.${ruleset}.charge`

    cy.log(`Testing '${ruleset}' when period is ${periodStart}-${periodEnd} it's before ruleset start of ${startDate}`)

    cy.fixture(fixtureName).then((fixture) => {
      fixture.ruleset = ruleset
      fixture.periodStart = periodStart
      fixture.periodEnd = periodEnd

      CalculateChargeEndpoints.calculate(fixture, false).then((response) => {
        expect(response.status).to.equal(422)
        expect(response.body.message)
          .to
          .equal(`"periodStart" must be greater than or equal to "${startDate}T00:00:00.000Z"`)
      })
    })
  })
})
