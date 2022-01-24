class CustomerEndpoints {
  static create (body, failOnStatusCode = true) {
    return cy
      .api({
        method: 'POST',
        url: '/v3/wrls/customer-changes',
        failOnStatusCode,
        headers: {
          'content-type': 'application/json',
          accept: 'application/json',
          Authorization: `Bearer ${Cypress.env('token')}`
        },
        body
      })
  }

  static list (days = '', failOnStatusCode = true) {
    return cy
      .api({
        method: 'GET',
        url: `/v3/wrls/customer-files/${days}`,
        failOnStatusCode,
        headers: {
          'content-type': 'application/json',
          accept: 'application/json',
          Authorization: `Bearer ${Cypress.env('token')}`
        }
      })
  }
}

export default CustomerEndpoints
