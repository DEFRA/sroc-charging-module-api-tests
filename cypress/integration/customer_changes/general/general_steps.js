import { When, Then } from 'cypress-cucumber-preprocessor/steps'
import CustomerEndpoints from '../../../endpoints/customer_endpoints'

When('I make a valid customer change request', () => {
  cy.fixture('customer.change').then((customerChange) => {
    CustomerEndpoints.create(customerChange).then((response) => {
      cy.wrap(response).as('customerChangeResponse')
    })
  })
})

When('I make a customer change request and follow it with another change for the same customer', () => {
  cy.fixture('customer.change').then((customerChange) => {
    CustomerEndpoints.create(customerChange).then((response) => {
      expect(response.status).to.equal(201)

      customerChange.addressLine1 = '12 Furry Lane'

      CustomerEndpoints.create(customerChange).then((response) => {
        cy.wrap(response).as('customerChangeResponse')
      })
    })
  })
})

Then('I get a successful customer change response', () => {
  cy.get('@customerChangeResponse').then((response) => {
    expect(response.status).to.equal(201)
  })
})

When('I make an invalid customer change request', () => {
  cy.fixture('customer.change').then((customerChange) => {
    customerChange.region = ''

    CustomerEndpoints.create(customerChange, false).then((response) => {
      cy.wrap(response).as('customerChangeResponse')
    })
  })
})

Then('I get a failed response', () => {
  cy.get('@customerChangeResponse').then((response) => {
    expect(response.status).to.equal(422)
  })
})
