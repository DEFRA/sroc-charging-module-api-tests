import { When } from 'cypress-cucumber-preprocessor/steps'
import CustomerEndpoints from '../../../endpoints/customer_endpoints'

When('I do not send the following values I am told they are required', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const property = row[0]

    cy.log(`Testing property '${property}'.`)

    cy.fixture('customer.change').then((fixture) => {
      fixture[property] = ''

      CustomerEndpoints.create(fixture, false).then((response) => {
        expect(response.status).to.equal(422)
        expect(response.body.message).to.contain(`"${property}" is required`)
      })
    })
  })
})

When('I do not send the following values it confirms the change without error', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const property = row[0]

    cy.log(`Testing property '${property}'.`)

    cy.fixture('customer.change').then((fixture) => {
      fixture[property] = ''

      CustomerEndpoints.create(fixture, false).then((response) => {
        expect(response.status).to.equal(201)
      })
    })
  })
})

When('I send values that are too long I am told what their maximum length is', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const property = row[0]
    const maxLength = parseInt(row[1])
    const tooLongValue = makeRandomString(maxLength + 1)

    cy.log(`Testing property '${property}' and its max length of ${maxLength}`)

    cy.fixture('customer.change').then((fixture) => {
      fixture[property] = tooLongValue

      CustomerEndpoints.create(fixture, false).then((response) => {
        expect(response.status).to.equal(422)
        expect(response.body.message).to.contain(`"${property}" length must be less than or equal to ${maxLength} characters long`)
      })
    })
  })
})

When('I send values that are their maximum length it confirms the change without error', (dataTable) => {
  cy.wrap(dataTable.rawTable).each(row => {
    const property = row[0]
    const maxLength = parseInt(row[1])
    const maxLengthValue = makeRandomString(maxLength)

    cy.log(`Testing property '${property}' is accepted at its max length of ${maxLength}`)

    cy.fixture('customer.change').then((fixture) => {
      fixture[property] = maxLengthValue

      CustomerEndpoints.create(fixture, false).then((response) => {
        expect(response.status).to.equal(201)
      })
    })
  })
})

function makeRandomString (length) {
  let result = ''
  const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
  const charactersLength = characters.length

  for (let i = 0; i < length; i++) {
    result += characters.charAt(Math.floor(Math.random() * charactersLength))
  }

  return result
}
