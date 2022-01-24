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
}

export default CustomerEndpoints
