class BillRunEndpoints {
  static create (body) {
    return cy
      .api({
        method: 'POST',
        url: '/v2/wrls/bill-runs',
        headers: {
          'content-type': 'application/json',
          accept: 'application/json',
          Authorization: `Bearer ${Cypress.env('token')}`
        },
        body
      })
  }

  static view (id) {
    return cy
      .api({
        method: 'GET',
        url: `/v2/wrls/bill-runs/${id}`,
        headers: {
          'content-type': 'application/json',
          accept: 'application/json',
          Authorization: `Bearer ${Cypress.env('token')}`
        }
      })
  }

  static viewDeleted (id) {
    return cy
      .api({
        method: 'GET',
        url: `/v2/wrls/bill-runs/${id}`,
        failOnStatusCode: false,
        headers: {
          'content-type': 'application/json',
          accept: 'application/json',
          Authorization: `Bearer ${Cypress.env('token')}`
        }
      })
  }

  static generate (id) {
    return cy
      .api({
        method: 'PATCH',
        url: `/v2/wrls/bill-runs/${id}/generate`,
        headers: {
          'content-type': 'application/json',
          accept: 'application/json',
          Authorization: `Bearer ${Cypress.env('token')}`
        }
      })
  }

  static approve (id) {
    return cy
      .api({
        method: 'PATCH',
        url: `/v2/wrls/bill-runs/${id}/approve`,
        headers: {
          'content-type': 'application/json',
          accept: 'application/json',
          Authorization: `Bearer ${Cypress.env('token')}`
        }
      })
  }

  static send (id) {
    return cy
      .api({
        method: 'PATCH',
        url: `/v2/wrls/bill-runs/${id}/send`,
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

  static status (id) {
    return cy
      .api({
        method: 'GET',
        url: `/v2/wrls/bill-runs/${id}/status`,
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
