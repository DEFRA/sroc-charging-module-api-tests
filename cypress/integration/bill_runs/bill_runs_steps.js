import { And, When, Then } from 'cypress-cucumber-preprocessor/steps'
import BillRunEndpoints from '../../endpoints/bill_run_endpoints'
import TransactionEndpoints from '../../endpoints/transaction_endpoints'

When('I request a new bill run', () => {
  BillRunEndpoints.create({ region: 'A' }).then((response) => {
    expect(response.status).to.equal(201)
    cy.wrap(response.body.billRun).as('billRun')
  })
})

Then('the bill run ID and number are returned', () => {
  cy.get('@billRun').then((billRun) => {
    expect(billRun.id).not.to.equal(null)
    expect(billRun.billRunNumber).not.to.equal(null)
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

And('I add {int} {word} transactions to it', (numberToAdd, transactionType) => {
  cy.fixture(`${transactionType}.transaction`).then((transaction) => {
    transaction.customerReference = 'TH230000222'
    transaction.licenceNumber = 'TONY/TF9222/38'

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

Then('bill run status is updated to {string}', (status) => {
  cy.get('@billRun').then((billRun) => {
    BillRunEndpoints.pollForStatus(billRun.id, status).then((response) => {
      expect(response.status).to.equal(200)
      expect(response.body.status).to.equal(status)
    })
  })
})
