class LicenceEndpoints {
  static delete (id, licenceId, failOnStatusCode = true) {
    return cy
      .api({
        method: 'DELETE',
        url: `/v2/wrls/bill-runs/${id}/licences/${licenceId}`,
        failOnStatusCode,
        headers: {
          'content-type': 'application/json',
          accept: 'application/json',
          Authorization: `Bearer ${Cypress.env('token')}`
        }
      })
  }
}

export default LicenceEndpoints
