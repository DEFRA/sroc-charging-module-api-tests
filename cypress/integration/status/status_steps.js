import { Given, Then } from 'cypress-cucumber-preprocessor/steps'
import StatusEndpoints from '../../endpoints/status_endpoints'

Given('I request the /status endpoint', () => {
  StatusEndpoints.view().as('response')
})

Then('the status response is as expected', () => {
  cy.get('@response').then((response) => {
    expect(response.status).to.equal(200)

    expect(response.body.status).to.equal('alive')
  })
})
