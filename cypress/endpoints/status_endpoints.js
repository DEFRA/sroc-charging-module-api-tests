class StatusEndpoints {
  static view () {
    return cy
      .api({
        method: 'GET',
        url: '/status',
        headers: {
          'content-type': 'application/json',
          accept: 'application/json'
        }
      })
  }
}

export default StatusEndpoints
