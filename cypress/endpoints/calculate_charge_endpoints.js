class CalculateChargeEndpoints {
  static calculate (body, failOnStatusCode = true) {
    return cy
      .api({
        method: 'POST',
        url: '/v3/wrls/calculate-charge',
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

export default CalculateChargeEndpoints
