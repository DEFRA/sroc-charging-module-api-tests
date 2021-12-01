class TransactionEndpoints {
  static create (billRunId, body, failOnStatusCode = true) {
    return cy
      .api({
        method: 'POST',
        url: `/v3/wrls/bill-runs/${billRunId}/transactions`,
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

export default TransactionEndpoints
