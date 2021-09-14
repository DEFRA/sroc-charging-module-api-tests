class RegimeEndpoints {
  static list () {
    return cy
      .api({
        method: 'GET',
        url: '/admin/regimes',
        headers: {
          'content-type': 'application/json',
          accept: 'application/json',
          Authorization: `Bearer ${Cypress.env('token')}`
        }
      })
  }

  static view (id) {
    return cy
      .api({
        method: 'GET',
        url: `/admin/regimes/${id}`,
        headers: {
          'content-type': 'application/json',
          accept: 'application/json',
          Authorization: `Bearer ${Cypress.env('token')}`
        }
      })
  }
}

export default RegimeEndpoints
