import { And, Then } from 'cypress-cucumber-preprocessor/steps'
import TransactionEndpoints from '../../endpoints/transaction_endpoints'

And('I add {int} {word} transactions to it', (numberToAdd, transactionType) => {
  cy.fixture(`${transactionType}.presroc.transaction`).then((transaction) => {
    transaction.customerReference = 'C000000001'
    transaction.licenceNumber = 'LIC/00000/01'

    cy.get('@billRun').then((billRun) => {
      // Due to the async nature of Cypress a classic `for` or `while` loop will not work because it will result in a
      // non-deterministic execution order. So, we generate an array from our param using `Array.from`. For example,
      // 5 would become [1, 2, 3, 4, 5]. We then use Cypress `each()` function to give us an async iterator!
      //
      // > Cypress each() - Iterate through an array like structure (arrays or objects with a length property).
      // - solution provided by https://stackoverflow.com/a/53487016/6117745
      const genArr = Array.from({ length: numberToAdd }, (v) => v)
      cy.wrap(genArr).each(() => {
        TransactionEndpoints.create(billRun.id, transaction)
      })
    })
  })
})

And('I add a {word} {word} transaction to it', (transactionType, ruleset) => {
  const fixtureName = `${transactionType}.${ruleset}.transaction`
  const uuid = require('uuid')

  const clientID = uuid.v4()

  cy.fixture(fixtureName).then((fixture) => {
    fixture.clientId = clientID
    cy.get('@billRun').then((billRun) => {
      TransactionEndpoints.create(billRun.id, fixture, false).then((response) => {
        cy.wrap(response).as('transaction')
      })
    })
  })
})

And('I add a successful {word} {word} transaction for customer {word}', (ruleset, transactionType, customerRef) => {
  const fixtureName = `${transactionType}.${ruleset}.transaction`

  const uuid = require('uuid')
  const clientID = uuid.v4()

  cy.fixture(fixtureName).then((fixture) => {
    fixture.clientId = clientID
    fixture.customerReference = customerRef
    cy.wrap(fixture).as('fixture')
    cy.get('@billRun').then((billRun) => {
      TransactionEndpoints.create(billRun.id, fixture, false).then((response) => {
        expect(response.status).to.equal(201)
        expect(response.body).to.have.property('transaction')
        expect(response.body.transaction.id).not.to.equal(null)
        expect(response.body.transaction.clientId).not.to.equal(null)
      })
    })
  })
})

And('I add a successful transaction with the following details', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const transactionType = row[0]
    const ruleset = row[1]
    const customerRef = row[2]
    const licenceNumber = row[3]
    const chargeValue = row[4]

    const fixtureName = `${transactionType}.${ruleset}.transaction`

    const uuid = require('uuid')
    const clientID = uuid.v4()

    const chargeAdjustment = chargeValue / 10

    cy.fixture(fixtureName).then((fixture) => {
      fixture.clientId = clientID
      fixture.customerReference = customerRef
      fixture.licenceNumber = licenceNumber

      if (ruleset === 'presroc') {
        fixture.section126Factor = chargeAdjustment
      } else {
        fixture.abatementFactor = chargeAdjustment
      }
      cy.wrap(fixture).as('fixture')
      cy.get('@billRun').then((billRun) => {
        TransactionEndpoints.create(billRun.id, fixture, false).then((response) => {
          expect(response.status).to.equal(201)
          expect(response.body).to.have.property('transaction')
          expect(response.body.transaction.id).not.to.equal(null)
          expect(response.body.transaction.clientId).not.to.equal(null)
        })
      })
    })
  })
})

And('I add an invalid {word} transaction to it', (ruleset) => {
  const fixtureName = `standard.${ruleset}.transaction`

  cy.log(`Sending invalid '${ruleset}' transaction request`)

  cy.fixture(fixtureName).then((fixture) => {
    fixture.periodStart = ' '
    cy.get('@billRun').then((billRun) => {
      TransactionEndpoints.create(billRun.id, fixture, false).then((response) => {
        cy.wrap(response).as('transaction')
      })
    })
  })
})

Then('I get a successful response from the POST /transactions endpoint', () => {
  cy.log('Testing valid transaction')

  cy.get('@transaction').then((response) => {
    expect(response.status).to.equal(201)
    expect(response.body).to.have.property('transaction')
    expect(response.body.transaction.id).not.to.equal(null)
    expect(response.body.transaction.clientId).not.to.equal(null)
  })
})

Then('I get a failed response', () => {
  cy.log('Testing invalid transaction')

  cy.get('@transaction').then((response) => {
    expect(response.status).to.equal(422)
    expect(response.body).to.have.property('error')
  })
})
