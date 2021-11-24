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
    const property = row[1]
    const defaultValue = Number(row[2])
    const fixtureName = `calculate.${ruleset}.charge`

    cy.log(`Testing '${ruleset}' property '${property}' when not set results in same charge value when it is set`)

    // Using the assumption that if the charge value, when all other things are equal, is the same when the property is
    // not set and when set with the default value we can conclude that the CM defaults it as expected.
    cy.fixture(fixtureName).then((fixture) => {
      const blankedFixture = { ...fixture }
      blankedFixture[property] = null

      const populatedFixture = { ...fixture }
      populatedFixture[property] = defaultValue

      CalculateChargeEndpoints.calculate(blankedFixture).then((response) => {
        const defaultedChargeValue = response.body.calculation.chargeValue

        CalculateChargeEndpoints.calculate(populatedFixture).then((response) => {
          expect(response.body.calculation.chargeValue).to.equal(defaultedChargeValue)
        })
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

When('I send the following properties as decimals I am told they should be integers', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const ruleset = row[0]
    const property = row[1]
    const fixtureName = `calculate.${ruleset}.charge`

    cy.log(`Testing '${ruleset}' integer property '${property}' doesn't like decimals`)

    cy.fixture(fixtureName).then((fixture) => {
      fixture.ruleset = ruleset
      fixture[property] = 1.1

      CalculateChargeEndpoints.calculate(fixture, false).then((response) => {
        expect(response.status).to.equal(422)
        expect(response.body.message).to.contain(`"${property}" must be an integer`)
      })
    })
  })
})

When('I send the following properties as decimals calculates the charge without error', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const ruleset = row[0]
    const property = row[1]
    const fixtureName = `calculate.${ruleset}.charge`

    cy.log(`Testing '${ruleset}' number property '${property}' likes decimals`)

    cy.fixture(fixtureName).then((fixture) => {
      fixture.ruleset = ruleset
      fixture[property] = 1.1

      CalculateChargeEndpoints.calculate(fixture, false).then((response) => {
        expect(response.status).to.equal(200)
        expect(response.body).to.have.property('calculation')
      })
    })
  })
})

When('I send the following properties at less than their minimum I am told what they should be', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const ruleset = row[0]
    const property = row[1]
    const minimum = row[2]
    const greaterThanOrEqualTo = row[3]
    const fixtureName = `calculate.${ruleset}.charge`

    cy.log(`Testing '${ruleset}' number property '${property}' is ${greaterThanOrEqualTo} a minimum of ${minimum}`)

    cy.fixture(fixtureName).then((fixture) => {
      fixture.ruleset = ruleset
      fixture[property] = Number(minimum) - 1

      CalculateChargeEndpoints.calculate(fixture, false).then((response) => {
        expect(response.status).to.equal(422)
        if (greaterThanOrEqualTo === '=') {
          expect(response.body.message).to.equal(`"${property}" must be greater than or equal to ${minimum}`)
        } else {
          expect(response.body.message).to.equal(`"${property}" must be greater than ${minimum}`)
        }
      })
    })
  })
})

When('I send the following properties at more than their maximum I am told what they should be', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const ruleset = row[0]
    const property = row[1]
    const maximum = row[2]
    const fixtureName = `calculate.${ruleset}.charge`

    cy.log(`Testing '${ruleset}' number property '${property}' is less than or equal to a maximum of ${maximum}`)

    cy.fixture(fixtureName).then((fixture) => {
      fixture.ruleset = ruleset
      fixture[property] = Number(maximum) + 1

      CalculateChargeEndpoints.calculate(fixture, false).then((response) => {
        expect(response.status).to.equal(422)
        expect(response.body.message).to.equal(`"${property}" must be less than or equal to ${maximum}`)
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

When('I send the following invalid combinations I am told what value a property should be', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const ruleset = row[0]
    const property1 = row[1]
    const property1Value = row[2]
    const property2 = row[3]
    const property2Value = row[4]
    const mustBeValue = row[5]
    const fixtureName = `calculate.${ruleset}.charge`

    cy.log(`Testing '${ruleset}' combination ${property1}=${property1Value} and ${property2}=${property2Value}`)

    cy.fixture(fixtureName).then((fixture) => {
      fixture.ruleset = ruleset
      // TODO: Remove and set as false in the fixture when https://eaflood.atlassian.net/browse/CMEA-193 is fixed
      fixture.compensationCharge = false
      fixture[property1] = (property1Value === 'true')
      fixture[property2] = (property2Value === 'true')

      CalculateChargeEndpoints.calculate(fixture, false).then((response) => {
        expect(response.status).to.equal(422)
        expect(response.body.message).to.equal(`"${property2}" must be [${mustBeValue}]`)
      })
    })
  })
})

When('I send the following valid combinations it calculates the charge without error', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const ruleset = row[0]
    const property1 = row[1]
    const property1Value = row[2]
    const property2 = row[3]
    const property2Value = row[4]
    const fixtureName = `calculate.${ruleset}.charge`

    cy.log(`Testing '${ruleset}' combination ${property1}=${property1Value} and ${property2}=${property2Value}`)

    cy.fixture(fixtureName).then((fixture) => {
      fixture.ruleset = ruleset
      // TODO: Remove and set as false in the fixture when https://eaflood.atlassian.net/browse/CMEA-193 is fixed
      fixture.compensationCharge = false
      fixture[property1] = (property1Value === 'true')
      fixture[property2] = (property2Value === 'true')

      CalculateChargeEndpoints.calculate(fixture, false).then((response) => {
        expect(response.status).to.equal(200)
        expect(response.body).to.have.property('calculation')
      })
    })
  })
})

When('I send the following properties it corrects the case and calculates the charge without error', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const ruleset = row[0]
    const property = row[1]
    const value = row[2]
    const fixtureName = `calculate.${ruleset}.charge`

    cy.log(`Testing '${ruleset}' corrects the case for '${property}' when the value is '${value}'`)

    cy.fixture(fixtureName).then((fixture) => {
      fixture.ruleset = ruleset
      // The CM will throw an error if supportedSourceName is defined but supportedSource is false. So, we need a bit
      // of logic to handle this when testing supportedSourceName
      fixture.supportedSource = (property === 'supportedSourceName')
      fixture[property] = value

      CalculateChargeEndpoints.calculate(fixture, false).then((response) => {
        expect(response.status).to.equal(200)
        expect(response.body).to.have.property('calculation')
      })
    })
  })
})

When('I send the following supported source values I get the expected response', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const ruleset = row[0]
    const supportedSource = row[1]
    const supportedSourceName = row[2]
    const expectedStatus = row[3]
    const fixtureName = `calculate.${ruleset}.charge`

    cy.log(`Testing '${ruleset}' supportedSource=${supportedSource} and supportedSourceName='${supportedSourceName}'`)

    cy.fixture(fixtureName).then((fixture) => {
      fixture.ruleset = ruleset
      fixture.supportedSource = supportedSource
      fixture.supportedSourceName = supportedSourceName

      CalculateChargeEndpoints.calculate(fixture, false).then((response) => {
        if (expectedStatus === '200') {
          expect(response.status).to.equal(200)
          expect(response.body).to.have.property('calculation')
        } else {
          expect(response.status).to.equal(422)

          if ((supportedSource === 'true')) {
            // If supported source was true then we get this error because supportedSourceName is null/undefined
            expect(response.body.message).to.equal('"supportedSourceName" is required')
          } else {
            // If supported source was false we get this error if supportedSourceName is set
            expect(response.body.message).to.equal('"supportedSourceName" is not allowed')
          }
        }
      })
    })
  })
})
