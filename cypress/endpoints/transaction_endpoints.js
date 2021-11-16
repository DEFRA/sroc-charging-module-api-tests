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
}

export default TransactionEndpoints
