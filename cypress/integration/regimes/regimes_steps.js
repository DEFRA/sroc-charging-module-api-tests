import { When, Then } from 'cypress-cucumber-preprocessor/steps'
import RegimeEndpoints from '../../endpoints/regime_endpoints'

When('I request a list of all regimes', () => {
  RegimeEndpoints.list().as('response')
})

Then('a summary of all regimes is returned', () => {
  const regimeKeys = ['id', 'slug', 'name', 'preSrocCutoffDate', 'createdAt', 'updatedAt']
  cy.get('@response').then((response) => {
    expect(response.status).to.equal(200)
    expect(response.body).to.be.an('array').that.is.lengthOf(4)
    expect(response.body[0]).to.be.an('object').that.has.all.keys(regimeKeys)
  })
})

When('I request to view a regime', () => {
  RegimeEndpoints.list().then((response) => {
    expect(response.status).to.equal(200)

    cy.wrap(response.body[0]).as('listRegime')
  })

  cy.get('@listRegime').then((regime) => {
    RegimeEndpoints.view(regime.id).then((response) => {
      expect(response.status).to.equal(200)

      cy.wrap(response.body).as('viewRegime')
    })
  })
})

Then('details of the regime are returned', () => {
  cy.get('@listRegime').then((listRegime) => {
    cy.get('@viewRegime').then((viewRegime) => {
      expect(viewRegime.id).to.equal(listRegime.id)
      expect(viewRegime.slug).to.equal(listRegime.slug)
      expect(viewRegime.name).to.equal(listRegime.name)
      expect(viewRegime.preSrocCutoffDate).to.equal(listRegime.preSrocCutoffDate)
      expect(viewRegime.createdAt).to.equal(listRegime.createdAt)
      expect(viewRegime.updatedAt).to.equal(listRegime.updatedAt)
      expect(viewRegime.authorisedSystems).to.be.an('array')
    })
  })
})
