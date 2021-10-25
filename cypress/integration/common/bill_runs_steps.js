// We disable this rule to prevent chai matchers like `to.be.empty` causing linting errors:
/* eslint-disable no-unused-expressions */

import { And, When, Then } from 'cypress-cucumber-preprocessor/steps'
import BillRunEndpoints from '../../endpoints/bill_run_endpoints'
import TransactionEndpoints from '../../endpoints/transaction_endpoints'

When('I request a valid new bill run', () => {
  BillRunEndpoints.create({ region: 'A' }).then((response) => {
    expect(response.status).to.equal(201)
    cy.wrap(response.body.billRun).as('billRun')
  })
})

And('I request another valid new bill run', () => {
  BillRunEndpoints.create({ region: 'A' }).then((response) => {
    expect(response.status).to.equal(201)
    cy.wrap(response.body.billRun).as('billRun1')
  })
})

When('I request an invalid new bill run', () => {
  BillRunEndpoints.createInvalid({ region: ' ' }).then((response) => {
    expect(response.status).to.equal(422)
    cy.wrap(response.body).as('error')
  })
})

When('I request a valid new {word} bill run for {word}', (rulesetType, regionCode) => {
  BillRunEndpoints.create({ region: `${regionCode}`, ruleset: `${rulesetType}` }).then((response) => {
    expect(response.status).to.equal(201)
    cy.wrap(response.body.billRun).as('billRun')
  })
})

When('I request an invalid new {word} bill run for {word}', (rulesetType, regionCode) => {
  BillRunEndpoints.createInvalid({ region: `${regionCode}`, ruleset: `${rulesetType}` }).then((response) => {
    expect(response.status).to.equal(422)
    cy.wrap(response.body).as('error')
  })
})

Then('I am told that acceptable values are presroc or sroc', () => {
  cy.get('@error').then((error) => {
    expect(error.message).to.equal('"ruleset" must be one of [presroc, sroc]')
  })
})

Then('I am told that region must be one of A, B, E, N, S, T, W, Y', () => {
  cy.get('@error').then((error) => {
    expect(error.message).to.equal('"region" must be one of [A, B, E, N, S, T, W, Y]')
  })
})

Then('I am told that region is required', () => {
  cy.get('@error').then((error) => {
    expect(error.message).to.equal('"region" is required')
  })
})

Then('the bill run ID and number are returned', () => {
  cy.get('@billRun').then((billRun) => {
    expect(billRun.id).not.to.equal(null)
    expect(billRun.billRunNumber).not.to.equal(null)
  })
})

Then('the bill run numbers are issued in ascending order', () => {
  cy.get('@billRun').then((billRun) => {
    cy.get('@billRun1').then((billRun1) => {
      expect(billRun1.billRunNumber).to.equal(billRun.billRunNumber + 1)
    })
  })
})

When('I request to view a bill run', () => {
  BillRunEndpoints.create({ region: 'A' }).then((response) => {
    expect(response.status).to.equal(201)
    cy.wrap(response.body.billRun).as('billRun')
  })
})

Then('details of the bill run are returned', () => {
  cy.get('@billRun').then((billRun) => {
    BillRunEndpoints.view(billRun.id).then((response) => {
      expect(response.status).to.equal(200)

      expect(response.body).to.have.property('billRun')

      expect(response.body.billRun.id).to.equal(billRun.id)
      expect(response.body.billRun.billRunNumber).to.equal(billRun.billRunNumber)

      expect(response.body.billRun.region).to.equal('A')
      expect(response.body.billRun.status).to.equal('initialised')
    })
  })
})

Then('the bill run does not contain any transactions', () => {
  cy.get('@billRun').then((billRun) => {
    BillRunEndpoints.view(billRun.id).then((response) => {
      expect(response.status).to.equal(200)

      expect(response.body.billRun.invoices).to.be.empty
    })
  })
})

And('I add {int} {word} transactions to it', (numberToAdd, transactionType) => {
  cy.fixture(`${transactionType}.transaction`).then((transaction) => {
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

And('I request to generate the bill run', () => {
  cy.get('@billRun').then((billRun) => {
    BillRunEndpoints.generate(billRun.id).then((response) => {
      expect(response.status).to.be.equal(204)
    })
  })
})

And('I request to approve the bill run', () => {
  cy.get('@billRun').then((billRun) => {
    BillRunEndpoints.approve(billRun.id).then((response) => {
      expect(response.status).to.be.equal(204)
    })
  })
})

And('I request to send the bill run', () => {
  cy.get('@billRun').then((billRun) => {
    BillRunEndpoints.send(billRun.id).then((response) => {
      expect(response.status).to.be.equal(204)
    })
  })
})

And('I request to delete the bill run', () => {
  cy.get('@billRun').then((billRun) => {
    BillRunEndpoints.delete(billRun.id).then((response) => {
      expect(response.status).to.be.equal(204)
    })
  })
})

Then('bill run is not found', () => {
  cy.get('@billRun').then((billRun) => {
    BillRunEndpoints.viewDeleted(billRun.id).then((response) => {
      expect(response.status).to.equal(404)
      expect(response.body.error).to.equal('Not Found')
      expect(response.body.message).to.equal('Bill run ' + billRun.id + ' is unknown.')
    })
  })
})

Then('bill run status is updated to {string}', (status) => {
  cy.get('@billRun').then((billRun) => {
    BillRunEndpoints.pollForStatus(billRun.id, status).then((response) => {
      expect(response.status).to.equal(200)
      expect(response.body.status).to.equal(status)
    })
  })
})
