import { And, When, Then } from 'cypress-cucumber-preprocessor/steps'
import BillRunEndpoints from '../../../../endpoints/bill_run_endpoints'
import TransactionEndpoints from '../../../../endpoints/transaction_endpoints'
import InvoiceEndpoints from '../../../../endpoints/invoice_endpoints'

And('I have a billed {word} bill run', (ruleset) => {
  BillRunEndpoints.create({ ruleset, region: 'A' }).then((response) => {
    const sourceBillRunId = response.body.billRun.id

    cy.fixture(`standard.${ruleset}.transaction`).then((fixture) => {
      fixture.customerReference = 'CM00000001'
      TransactionEndpoints.create(sourceBillRunId, fixture, false).then(() => {
        cy.fixture(`credit.${ruleset}.transaction`).then((fixture) => {
          fixture.customerReference = 'CM00000002'
          TransactionEndpoints.create(sourceBillRunId, fixture, false).then(() => {
            cy.fixture(`minimumCharge.${ruleset}.transaction`).then((fixture) => {
              fixture.customerReference = 'CM00000003'
              TransactionEndpoints.create(sourceBillRunId, fixture, false).then(() => {
                cy.fixture(`deminimis.${ruleset}.transaction`).then((fixture) => {
                  fixture.customerReference = 'CM00000004'
                  TransactionEndpoints.create(sourceBillRunId, fixture, false).then(() => {
                    cy.fixture(`zeroValue.${ruleset}.transaction`).then((fixture) => {
                      fixture.customerReference = 'CM00000005'
                      TransactionEndpoints.create(sourceBillRunId, fixture, false).then(() => {
                        BillRunEndpoints.generate(sourceBillRunId).then(() => {
                          BillRunEndpoints.pollForStatus(sourceBillRunId, 'generated').then(() => {
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
                })
              })
            })
          })
        })
      })
    })
  })
})

And('I have an initialised {word} bill run', (ruleset) => {
  BillRunEndpoints.create({ ruleset, region: 'A' }).then((response) => {
    const sourceBillRunId = response.body.billRun.id

    cy.fixture(`standard.${ruleset}.transaction`).then((fixture) => {
      fixture.customerReference = 'CM00000001'
      TransactionEndpoints.create(sourceBillRunId, fixture, false).then(() => {
        BillRunEndpoints.pollForStatus(sourceBillRunId, 'initialised').then(() => {
          BillRunEndpoints.view(sourceBillRunId).then((response) => {
            cy.wrap(response.body.billRun).as('sourceBillRun')
                                  })
                                })
                              })
                            })
                          })
                        })


And('I have a generated {word} bill run', (ruleset) => {
  BillRunEndpoints.create({ ruleset, region: 'A' }).then((response) => {
    const sourceBillRunId = response.body.billRun.id

    cy.fixture(`standard.${ruleset}.transaction`).then((fixture) => {
      fixture.customerReference = 'CM00000001'
      TransactionEndpoints.create(sourceBillRunId, fixture, false).then(() => {
        BillRunEndpoints.generate(sourceBillRunId).then(() => {
          BillRunEndpoints.pollForStatus(sourceBillRunId, 'generated').then(() => {
                BillRunEndpoints.view(sourceBillRunId).then((response) => {
                  cy.wrap(response.body.billRun).as('sourceBillRun')
                                  })
                                })
                              })
                            })
                          })
                        })
                      })

And('I have an approved {word} bill run', (ruleset) => {
  BillRunEndpoints.create({ ruleset, region: 'A' }).then((response) => {
    const sourceBillRunId = response.body.billRun.id

    cy.fixture(`standard.${ruleset}.transaction`).then((fixture) => {
      fixture.customerReference = 'CM00000001'
      TransactionEndpoints.create(sourceBillRunId, fixture, false).then(() => {
        BillRunEndpoints.generate(sourceBillRunId).then(() => {
          BillRunEndpoints.pollForStatus(sourceBillRunId, 'generated').then(() => {
            BillRunEndpoints.approve(sourceBillRunId).then(() => {
              BillRunEndpoints.pollForStatus(sourceBillRunId, 'approved').then(() => {
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

When('I try to rebill a {word} invoice to a new {word} bill run', (invoiceType, ruleset) => {
  BillRunEndpoints.create({ ruleset, region: 'A' }).then((response) => {
    const destinationBillRunId = response.body.billRun.id
    const invoice = invoiceType

    cy.get('@sourceBillRun').then((sourceBillRun) => {
      if (invoice === 'debit') {
        const rebillInvoice = sourceBillRun.invoices.find(element => element.customerReference === 'CM00000001')
        InvoiceEndpoints.rebill(destinationBillRunId, rebillInvoice.id, false).then((response) => {
          cy.wrap(response).as('rebillResponse')
        })
      } else if (invoice === 'credit') {
        const rebillInvoice = sourceBillRun.invoices.find(element => element.customerReference === 'CM00000002')
        InvoiceEndpoints.rebill(destinationBillRunId, rebillInvoice.id, false).then((response) => {
          cy.wrap(response).as('rebillResponse')
        })
      } else if (invoice === 'minimumCharge') {
        const rebillInvoice = sourceBillRun.invoices.find(element => element.customerReference === 'CM00000003')
        InvoiceEndpoints.rebill(destinationBillRunId, rebillInvoice.id, false).then((response) => {
          cy.wrap(response).as('rebillResponse')
        })
      } else if (invoice === 'deminimis') {
        const rebillInvoice = sourceBillRun.invoices.find(element => element.customerReference === 'CM00000004')
        InvoiceEndpoints.rebill(destinationBillRunId, rebillInvoice.id, false).then((response) => {
          cy.wrap(response).as('rebillResponse')
        })
      } else if (invoice === 'zeroValue') {
        const rebillInvoice = sourceBillRun.invoices.find(element => element.customerReference === 'CM00000005')
        InvoiceEndpoints.rebill(destinationBillRunId, rebillInvoice.id, false).then((response) => {
          cy.wrap(response).as('rebillResponse')
        })
      }
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

When('I try to rebill an invoice to a new {word} bill run for a different region', (ruleset) => {
  BillRunEndpoints.create({ ruleset, region: 'B' }).then((response) => {
    cy.wrap(response).as('destinationBillRun')
    const destinationBillRunId = response.body.billRun.id

    cy.get('@sourceBillRun').then((sourceBillRun) => {
      const rebillInvoice = sourceBillRun.invoices.find(element => element.customerReference === 'CM00000001')

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

And('I am told the source invoice region is different to the destination bill run region', () => {
  cy.get('@sourceBillRun').then((sourceBillRun) => {
    const rebillInvoice = sourceBillRun.invoices.find(element => element.customerReference === 'CM00000001')
  cy.get('@destinationBillRun').then((destinationBillRun) => {
    const destinationBillRunId = destinationBillRun.body.billRun.id
  cy.get('@rebillResponse').then((response) => {
    expect(response.body.message).to.equal(`Invoice ${rebillInvoice.id} is for region A but bill run ${destinationBillRunId} is for region B.`)
  })
})
})
})

And('I am told the source bill run region does not have a status of billed', () => {
  cy.get('@sourceBillRun').then((sourceBillRun) => {
    const sourceBillRunId = sourceBillRun.id
  cy.get('@rebillResponse').then((response) => {
    expect(response.body.message).to.equal(`Bill run ${sourceBillRunId} does not have a status of 'billed'.`)
  })
})
})