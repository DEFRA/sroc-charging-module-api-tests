import { Then, When, And } from 'cypress-cucumber-preprocessor/steps'
// import BillRunEndpoints from '../../../endpoints/bill_run_endpoints'
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

And('I send the following properties with the wrong data types I am told what they should be', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const ruleset = row[0]
    const property = row[1]
    const correctDataType = row[2]
    const fixtureName = `standard.${ruleset}.transaction`

    cy.log(`Testing '${ruleset}' property '${property}' should be a ${correctDataType}`)

    cy.fixture(fixtureName).then((fixture) => {
      fixture.ruleset = ruleset
      fixture[property] = 'crazy'

      cy.get('@billRun').then((billRun) => {
        TransactionEndpoints.create(billRun.id, fixture, false).then((response) => {
          expect(response.status).to.equal(422)
          expect(response.body.message).to.contain(`"${property}" must be a ${correctDataType}`)
        })
      })
    })
  })
})

And('I send the following properties as decimals I am told they should be integers', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const ruleset = row[0]
    const property = row[1]
    const fixtureName = `standard.${ruleset}.transaction`

    cy.log(`Testing '${ruleset}' integer property '${property}' doesn't like decimals`)

    cy.fixture(fixtureName).then((fixture) => {
      fixture.ruleset = ruleset
      fixture[property] = 1.1

      cy.get('@billRun').then((billRun) => {
        TransactionEndpoints.create(billRun.id, fixture, false).then((response) => {
          expect(response.status).to.equal(422)
          expect(response.body.message).to.contain(`"${property}" must be an integer`)
        })
      })
    })
  })
})

And('I send the following properties as decimals creates the transaction without error', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const ruleset = row[0]
    const property = row[1]
    const fixtureName = `standard.${ruleset}.transaction`

    cy.log(`Testing '${ruleset}' number property '${property}' likes decimals`)

    cy.fixture(fixtureName).then((fixture) => {
      fixture[property] = 1.1

      cy.get('@billRun').then((billRun) => {
        TransactionEndpoints.create(billRun.id, fixture, false).then((response) => {
          expect(response.status).to.equal(201)
          expect(response.body).to.have.property('transaction')
        })
      })
    })
  })
})

And('I send the following properties at less than their minimum I am told what they should be', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const ruleset = row[0]
    const property = row[1]
    const minimum = row[2]
    const greaterThanOrEqualTo = row[3]
    const fixtureName = `standard.${ruleset}.transaction`

    cy.log(`Testing '${ruleset}' number property '${property}' is ${greaterThanOrEqualTo} a minimum of ${minimum}`)

    cy.fixture(fixtureName).then((fixture) => {
      fixture[property] = Number(minimum) - 1

      cy.get('@billRun').then((billRun) => {
        TransactionEndpoints.create(billRun.id, fixture, false).then((response) => {
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
})

And('I send the following properties at more than their maximum I am told what they should be', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const ruleset = row[0]
    const property = row[1]
    const maximum = row[2]
    const fixtureName = `standard.${ruleset}.transaction`

    cy.log(`Testing '${ruleset}' number property '${property}' is less than or equal to a maximum of ${maximum}`)

    cy.fixture(fixtureName).then((fixture) => {
      fixture[property] = Number(maximum) + 1

      cy.get('@billRun').then((billRun) => {
        TransactionEndpoints.create(billRun.id, fixture, false).then((response) => {
          expect(response.status).to.equal(422)
          expect(response.body.message).to.equal(`"${property}" must be less than or equal to ${maximum}`)
        })
      })
    })
  })
})

And('I send the following period start and end dates I am told what financial year periodEnd must be', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const ruleset = row[0]
    const periodStart = row[1]
    const periodEnd = row[2]
    const financialYear = row[3]
    const fixtureName = `standard.${ruleset}.transaction`

    cy.log(`Testing '${ruleset}' when period is ${periodStart}-${periodEnd} periodEnd year should be ${financialYear}`)

    cy.fixture(fixtureName).then((fixture) => {
      fixture.periodStart = periodStart
      fixture.periodEnd = periodEnd

      cy.get('@billRun').then((billRun) => {
        TransactionEndpoints.create(billRun.id, fixture, false).then((response) => {
          expect(response.status).to.equal(422)
          expect(response.body.message).to.equal(`"periodEndFinancialYear" must be [${financialYear}]`)
        })
      })
    })
  })
})

And('I send the following period dates I am told that periodStart must be less than or equal to periodEnd',
  (dataTable) => {
    cy.wrap(dataTable.rawTable).each(row => {
      const ruleset = row[0]
      const periodStart = row[1]
      const periodEnd = row[2]
      const fixtureName = `standard.${ruleset}.transaction`

      cy.log(`Testing '${ruleset}' when period is ${periodStart}-${periodEnd} periodStart is invalid`)

      cy.fixture(fixtureName).then((fixture) => {
        fixture.periodStart = periodStart
        fixture.periodEnd = periodEnd

        cy.get('@billRun').then((billRun) => {
          TransactionEndpoints.create(billRun.id, fixture, false).then((response) => {
            expect(response.status).to.equal(422)
            expect(response.body.message).to.equal('"periodStart" must be less than or equal to "ref:periodEnd"')
          })
        })
      })
    })
  })

And('I send the following period dates I am told that periodStart is before the ruleset start date', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const ruleset = row[0]
    const periodStart = row[1]
    const periodEnd = row[2]
    const startDate = row[3]
    const fixtureName = `standard.${ruleset}.transaction`

    cy.log(`Testing '${ruleset}' when period is ${periodStart}-${periodEnd} it's before ruleset start of ${startDate}`)

    cy.fixture(fixtureName).then((fixture) => {
      fixture.periodStart = periodStart
      fixture.periodEnd = periodEnd

      cy.get('@billRun').then((billRun) => {
        TransactionEndpoints.create(billRun.id, fixture, false).then((response) => {
          expect(response.status).to.equal(422)
          expect(response.body.message)
            .to
            .equal(`"periodStart" must be greater than or equal to "${startDate}T00:00:00.000Z"`)
        })
      })
    })
  })
})
