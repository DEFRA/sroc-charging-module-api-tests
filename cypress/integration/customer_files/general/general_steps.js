import { When, Then } from 'cypress-cucumber-preprocessor/steps'
import CustomerEndpoints from '../../../endpoints/customer_endpoints'

When('I make a valid customer files request', () => {
  CustomerEndpoints.list().then((response) => {
    cy.wrap(response).as('customerFilesResponse')
  })
})

Then('I get a successful customer files response', (type) => {
  cy.get('@customerFilesResponse').then((response) => {
    expect(response.status).to.equal(200)

    if (JSON.stringify(response.body) === '[]') {
      cy.log('Response was empty. This is fine and can happen in new systems.')
    } else {
      const firstEntry = response.body[0]

      expect(firstEntry.id).to.exist()
      expect(firstEntry.fileReference).to.exist()
      expect(firstEntry.status).to.exist()
      expect(firstEntry.exportedAt).to.exist()
      expect(firstEntry.exportedCustomers).to.exist()
    }
  })
})
