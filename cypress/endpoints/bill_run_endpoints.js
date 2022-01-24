class BillRunEndpoints {
  static create (body) {
    return cy
      .api({
        method: 'POST',
        url: '/v3/wrls/bill-runs',
        headers: {
          'content-type': 'application/json',
          accept: 'application/json',
          Authorization: `Bearer ${Cypress.env('token')}`
        },
        body
      })
  }

  static createInvalid (body) {
    return cy
      .api({
        method: 'POST',
        url: '/v3/wrls/bill-runs',
        failOnStatusCode: false,
        headers: {
          'content-type': 'application/json',
          accept: 'application/json',
          Authorization: `Bearer ${Cypress.env('token')}`
        },
        body
      })
  }

  static view (id, failOnStatusCode = true) {
    return cy
      .api({
        method: 'GET',
        url: `/v3/wrls/bill-runs/${id}`,
        failOnStatusCode,
        headers: {
          'content-type': 'application/json',
          accept: 'application/json',
          Authorization: `Bearer ${Cypress.env('token')}`
        }
      })
  }

  static generate (id, failOnStatusCode = true) {
    return cy
      .api({
        method: 'PATCH',
        url: `/v3/wrls/bill-runs/${id}/generate`,
        failOnStatusCode,
        headers: {
          'content-type': 'application/json',
          accept: 'application/json',
          Authorization: `Bearer ${Cypress.env('token')}`
        }
      })
  }

  static approve (id, failOnStatusCode = true) {
    return cy
      .api({
        method: 'PATCH',
        url: `/v3/wrls/bill-runs/${id}/approve`,
        failOnStatusCode,
        headers: {
          'content-type': 'application/json',
          accept: 'application/json',
          Authorization: `Bearer ${Cypress.env('token')}`
        }
      })
  }

  static send (id, failOnStatusCode = true) {
    return cy
      .api({
        method: 'PATCH',
        url: `/v3/wrls/bill-runs/${id}/send`,
        failOnStatusCode,
        headers: {
          'content-type': 'application/json',
          accept: 'application/json',
          Authorization: `Bearer ${Cypress.env('token')}`
        }
      })
  }

  static delete (id) {
    return cy
      .api({
        method: 'DELETE',
        url: `/v2/wrls/bill-runs/${id}`,
        headers: {
          'content-type': 'application/json',
          accept: 'application/json',
          Authorization: `Bearer ${Cypress.env('token')}`
        }
      })
  }

  static status (id, failOnStatusCode = true) {
    return cy
      .api({
        method: 'GET',
        url: `/v3/wrls/bill-runs/${id}/status`,
        failOnStatusCode,
        headers: {
          'content-type': 'application/json',
          accept: 'application/json',
          Authorization: `Bearer ${Cypress.env('token')}`
        }
      })
  }

  static pollForStatus (id, status) {
    return this.status(id)
      .then((response) => {
        cy.log(`Bill run status -> ${response.body.status}`)

        if (response.status === 200 && response.body.status === status) {
          // break out of the recursive loop
          return
        } else if (response.status !== 200) {
          // we're not expecting an error so bail if we get one
          return
        }
        // else use recursion to make the request again after a 1 second pause
        cy.wait(1000)
        this.pollForStatus(id, status)
      })
  }
}

export default BillRunEndpoints
