class InvoiceEndpoints {
  static view (id, invoiceId, failOnStatusCode = true) {
    return cy
      .api({
        method: 'GET',
        url: `/v3/wrls/bill-runs/${id}/invoices/${invoiceId}`,
        failOnStatusCode,
        headers: {
          'content-type': 'application/json',
          accept: 'application/json',
          Authorization: `Bearer ${Cypress.env('token')}`
        }
      })
  }

  static delete (id, invoiceId, failOnStatusCode = true) {
    return cy
      .api({
        method: 'DELETE',
        url: `/v3/wrls/bill-runs/${id}/invoices/${invoiceId}`,
        failOnStatusCode,
        headers: {
          'content-type': 'application/json',
          accept: 'application/json',
          Authorization: `Bearer ${Cypress.env('token')}`
        }
      })
  }
}

export default InvoiceEndpoints
