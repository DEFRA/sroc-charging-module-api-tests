// We disable this rule to prevent chai matchers like `to.be.empty` causing linting errors:
/* eslint-disable no-unused-expressions */

import { And, When, Then } from 'cypress-cucumber-preprocessor/steps'
import BillRunEndpoints from '../../endpoints/bill_run_endpoints'

When('I request a valid new {word} bill run', (ruleset) => {
  BillRunEndpoints.create({ region: 'A', ruleset: ruleset }).then((response) => {
    expect(response.status).to.equal(201)
    cy.wrap(response.body.billRun).as('billRun')
  })
})

And('I request another valid new {word} bill run', (ruleset) => {
  BillRunEndpoints.create({ region: 'A', ruleset: ruleset }).then((response) => {
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

When('I request a valid new {word} bill run for region {word}', (rulesetType, regionCode) => {
  BillRunEndpoints.create({ region: `${regionCode}`, ruleset: `${rulesetType}` }).then((response) => {
    expect(response.status).to.equal(201)
    cy.wrap(`${regionCode}`).as('billRunRegion')
    cy.wrap(`${rulesetType}`).as('rulesetType')
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

When('I request to view the bill run', () => {
  cy.get('@billRun').then((billRun) => {
    BillRunEndpoints.view(billRun.id).then((response) => {
      expect(response.status).to.be.equal(200)
      cy.wrap(response.body.billRun).as('viewBillRun')
    })
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

And('I request to generate the bill run', () => {
  cy.get('@billRun').then((billRun) => {
    BillRunEndpoints.generate(billRun.id, false).then((response) => {
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
