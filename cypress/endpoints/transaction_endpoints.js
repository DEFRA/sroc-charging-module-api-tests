class TransactionEndpoints {
  static create (billRunId, body) {
    return cy
      .api({
        method: 'POST',
        url: `/v2/wrls/bill-runs/${billRunId}/transactions`,
        headers: {
          'content-type': 'application/json',
          accept: 'application/json',
          Authorization: `Bearer ${Cypress.env('token')}`
        },
        body
      })
  }

  static calculateInvalid (body) {
    return cy
      .api({
        method: 'POST',
        url: '/v3/wrls/calculate-charge',
        failOnStatusCode: false,
        headers: {
          'content-type': 'application/json',
          accept: 'application/json',
          Authorization: `Bearer ${Cypress.env('token')}`
        },
        body
      })
  }

  static calculate (body) {
    return cy
      .api({
        method: 'POST',
        url: '/v3/wrls/calculate-charge',
        headers: {
          'content-type': 'application/json',
          accept: 'application/json',
          Authorization: `Bearer ${Cypress.env('token')}`
        },
        body
      })
  }
}

export default TransactionEndpoints
