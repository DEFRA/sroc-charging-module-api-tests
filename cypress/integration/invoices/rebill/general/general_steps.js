import { And, When, Then } from 'cypress-cucumber-preprocessor/steps'
import BillRunEndpoints from '../../../../endpoints/bill_run_endpoints'
import TransactionEndpoints from '../../../../endpoints/transaction_endpoints'
import InvoiceEndpoints from '../../../../endpoints/invoice_endpoints'

And('I have a billed {word} bill run', (ruleset) => {
  BillRunEndpoints.create({ ruleset, region: 'A' }).then((response) => {
    const sourceBillRunId = response.body.billRun.id

    cy.fixture(`standard.${ruleset}.transaction`).then((fixture) => {
      TransactionEndpoints.create(sourceBillRunId, fixture, false).then(() => {
        BillRunEndpoints.generate(sourceBillRunId).then(() => {
          BillRunEndpoints.approve(sourceBillRunId).then(() => {
            BillRunEndpoints.send(sourceBillRunId).then(() => {
              BillRunEndpoints.pollForStatus(sourceBillRunId, 'billed').then(() => {
                BillRunEndpoints.view(sourceBillRunId).then((response) => {
                  cy.wrap(response.body.billRun).as('sourceBillRun')
                })
              })
            })
          })
        })
      })
    })
  })
})

When('I try to rebill it to a new {word} bill run', (ruleset) => {
  BillRunEndpoints.create({ ruleset, region: 'A' }).then((response) => {
    const destinationBillRunId = response.body.billRun.id

    cy.get('@sourceBillRun').then((sourceBillRun) => {
      const rebillInvoice = sourceBillRun.invoices[0]

      InvoiceEndpoints.rebill(destinationBillRunId, rebillInvoice.id, false).then((response) => {
        cy.wrap(response).as('rebillResponse')
      })
    })
  })
})

When('I try to rebill it to a generated {word} bill run', (ruleset) => {
  BillRunEndpoints.create({ ruleset, region: 'A' }).then((response) => {
    const destinationBillRunId = response.body.billRun.id

    cy.fixture(`standard.${ruleset}.transaction`).then((fixture) => {
      TransactionEndpoints.create(destinationBillRunId, fixture, false).then(() => {
        BillRunEndpoints.generate(destinationBillRunId).then(() => {
          BillRunEndpoints.pollForStatus(destinationBillRunId, 'generated').then(() => {
            cy.get('@sourceBillRun').then((sourceBillRun) => {
              const rebillInvoice = sourceBillRun.invoices[0]

              InvoiceEndpoints.rebill(destinationBillRunId, rebillInvoice.id, false).then((response) => {
                cy.wrap(response).as('rebillResponse')
              })
            })
          })
        })
      })
    })
  })
})

When('I try to rebill it to an approved {word} bill run', (ruleset) => {
  BillRunEndpoints.create({ ruleset, region: 'A' }).then((response) => {
    const destinationBillRunId = response.body.billRun.id

    cy.fixture(`standard.${ruleset}.transaction`).then((fixture) => {
      TransactionEndpoints.create(destinationBillRunId, fixture, false).then(() => {
        BillRunEndpoints.generate(destinationBillRunId).then(() => {
          BillRunEndpoints.approve(destinationBillRunId).then(() => {
            BillRunEndpoints.pollForStatus(destinationBillRunId, 'approved').then(() => {
              cy.get('@sourceBillRun').then((sourceBillRun) => {
                const rebillInvoice = sourceBillRun.invoices[0]

                InvoiceEndpoints.rebill(destinationBillRunId, rebillInvoice.id, false).then((response) => {
                  cy.wrap(response).as('rebillResponse')
                })
              })
            })
          })
        })
      })
    })
  })
})

When('I try to rebill it to a billed {word} bill run', (ruleset) => {
  BillRunEndpoints.create({ ruleset, region: 'A' }).then((response) => {
    const destinationBillRunId = response.body.billRun.id

    cy.fixture(`standard.${ruleset}.transaction`).then((fixture) => {
      TransactionEndpoints.create(destinationBillRunId, fixture, false).then(() => {
        BillRunEndpoints.generate(destinationBillRunId).then(() => {
          BillRunEndpoints.approve(destinationBillRunId).then(() => {
            BillRunEndpoints.send(destinationBillRunId).then(() => {
              BillRunEndpoints.pollForStatus(destinationBillRunId, 'billed').then(() => {
                cy.get('@sourceBillRun').then((sourceBillRun) => {
                  const rebillInvoice = sourceBillRun.invoices[0]

                  InvoiceEndpoints.rebill(destinationBillRunId, rebillInvoice.id, false).then((response) => {
                    cy.wrap(response).as('rebillResponse')
                  })
                })
              })
            })
          })
        })
      })
    })
  })
})

Then('I get a failed response', () => {
  cy.get('@rebillResponse').then((response) => {
    expect(response.status).to.equal(422)
    expect(response.body).to.have.property('error')
  })
})

Then('I get a conflict response', () => {
  cy.get('@rebillResponse').then((response) => {
    expect(response.status).to.equal(409)
    expect(response.body).to.have.property('error')
  })
})

Then('I get a successful response that includes details for the invoices created', () => {
  cy.get('@rebillResponse').then((response) => {
    expect(response.status).to.equal(201)
    expect(response.body).to.have.property('invoices')

    const creditInvoice = response.body.invoices[0]
    const rebillInvoice = response.body.invoices[1]

    expect(creditInvoice).to.have.property('id')
    expect(creditInvoice.rebilledType).to.equal('C')

    expect(rebillInvoice).to.have.property('id')
    expect(rebillInvoice.rebilledType).to.equal('R')
  })
})
