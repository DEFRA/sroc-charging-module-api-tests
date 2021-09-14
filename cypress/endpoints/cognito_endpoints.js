class CognitoEndpoints {
  static create (user) {
    const credentials = this._credentials(user)
    const encodedCredentials = this._encodeCredentials(credentials)

    cy
      .api({
        method: 'POST',
        url: this._url(),
        headers: {
          'content-type': 'application/x-www-form-urlencoded',
          accept: 'application/json',
          Authorization: `Basic ${encodedCredentials}`
        }
      })
      .then(({ body }) => {
        Cypress.env('token', body.access_token)
      })
  }

  static _url () {
    return `${Cypress.env('TOKEN_URL')}?grant_type=client_credentials`
  }

  static _credentials (user) {
    return {
      user: user === 'admin' ? Cypress.env('ADMIN_USER') : Cypress.env('SYSTEM_USER'),
      password: user === 'admin' ? Cypress.env('ADMIN_PASSWORD') : Cypress.env('SYSTEM_PASSWORD')
    }
  }

  static _encodeCredentials (credentials) {
    const keys = `${credentials.user}:${credentials.password}`

    return Buffer.from(keys).toString('base64')
  }
}

export default CognitoEndpoints
