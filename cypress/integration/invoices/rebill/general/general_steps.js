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
    cy.wrap(response).as('destinationBillRun')
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
    cy.wrap(response).as('destinationBillRun')
    const destinationBillRunId = response.body.billRun.id

    cy.get('@sourceBillRun').then((sourceBillRun) => {
      const rebillInvoice = sourceBillRun.invoices[0]

      InvoiceEndpoints.rebill(destinationBillRunId, rebillInvoice.id, false).then((response) => {
        cy.wrap(response).as('rebillResponse')
      })
    })
  })
})

And('I request the new destination bill run to be billed', (ruleset) => {
  cy.get('@destinationBillRun').then((destinationBillRun) => {
    const sourceBillRunId = destinationBillRun.body.billRun.id
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

When('I try to rebill the same invoice to the same new {word} bill run', (ruleset) => {
  cy.get('@destinationBillRun').then((destinationBillRun) => {
    const destinationBillRunId = destinationBillRun.body.billRun.id

    cy.get('@sourceBillRun').then((sourceBillRun) => {
      const rebillInvoice = sourceBillRun.invoices[0]

      InvoiceEndpoints.rebill(destinationBillRunId, rebillInvoice.id, false).then((response) => {
        cy.wrap(response).as('rebillResponse')
      })
    })
  })
})

When('I try to rebill the same invoice to a new {word} bill run', (ruleset) => {
  BillRunEndpoints.create({ ruleset, region: 'A' }).then((response) => {
    cy.wrap(response).as('destinationBillRun')
    const destinationBillRunId = response.body.billRun.id

    cy.get('@sourceBillRun').then((sourceBillRun) => {
      const rebillInvoice = sourceBillRun.invoices[0]

      InvoiceEndpoints.rebill(destinationBillRunId, rebillInvoice.id, false).then((response) => {
        cy.wrap(response).as('rebillResponse')
      })
    })
  })
})

When('I try to rebill the cancel invoice to a new {word} bill run', (ruleset) => {
  BillRunEndpoints.create({ ruleset, region: 'A' }).then((response) => {
    cy.wrap(response).as('destinationBillRun')
    const destinationBillRunId = response.body.billRun.id

    cy.get('@sourceBillRun').then((sourceBillRun) => {
      const cancelInvoice = sourceBillRun.invoices[0]
      expect(sourceBillRun.invoices[0].rebilledType).to.equal('C')

      InvoiceEndpoints.rebill(destinationBillRunId, cancelInvoice.id, false).then((response) => {
        cy.wrap(response).as('rebillResponse')
      })
    })
  })
})

When('I try to rebill the rebill invoice to a new {word} bill run', (ruleset) => {
  BillRunEndpoints.create({ ruleset, region: 'A' }).then((response) => {
    cy.wrap(response).as('destinationBillRun')
    const destinationBillRunId = response.body.billRun.id

    cy.get('@sourceBillRun').then((sourceBillRun) => {
      const rebillInvoice = sourceBillRun.invoices[1]
      expect(sourceBillRun.invoices[1].rebilledType).to.equal('R')

      InvoiceEndpoints.rebill(destinationBillRunId, rebillInvoice.id).then((response) => {
        cy.wrap(response).as('rebillResponse')
      })
    })
  })
})

When('I try to rebill it to an initialised {word} bill run', (ruleset) => {
  BillRunEndpoints.create({ ruleset, region: 'A' }).then((response) => {
    const destinationBillRunId = response.body.billRun.id

    cy.fixture(`standard.${ruleset}.transaction`).then((fixture) => {
      TransactionEndpoints.create(destinationBillRunId, fixture, false).then(() => {
        BillRunEndpoints.pollForStatus(destinationBillRunId, 'initialised').then(() => {
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

And('the credit C invoice includes all transactions', () => {
  cy.get('@sourceBillRun').then((sourceBillRun) => {
    const originalBillRun = sourceBillRun
    const originalInvoice = sourceBillRun.invoices[0]

    cy.get('@destinationBillRun').then((destinationBillRun) => {
      const destinationBillRun1 = destinationBillRun.body.billRun
      cy.get('@rebillResponse').then((response) => {
        const creditInvoice = response.body.invoices[0]

        InvoiceEndpoints.view(originalBillRun.id, originalInvoice.id, false).then((response1) => {
          const sourceInvoice = response1.body.invoice
          const sourceLicence = sourceInvoice.licences[0]
          const sourceTransactions = sourceLicence.transactions[0]
          InvoiceEndpoints.view(destinationBillRun1.id, creditInvoice.id, false).then((response2) => {
            const creditInvoice = response2.body.invoice
            const creditLicence = creditInvoice.licences[0]
            const creditTransactions = creditLicence.transactions[0]

            function posToNeg (num) {
              return -Math.abs(num)
            }

            cy.log('Testing source invoice transactions against rebill (C) credit invoice transactions')

            expect(sourceInvoice.ruleset).to.equal(creditInvoice.ruleset)
            expect(sourceInvoice.customerReference).to.equal(creditInvoice.customerReference)
            expect(sourceInvoice.financialYear).to.equal(creditInvoice.financialYear)
            expect(sourceInvoice.deminimisInvoice).to.equal(creditInvoice.deminimisInvoice)
            expect(sourceInvoice.zeroValueInvoice).to.equal(creditInvoice.zeroValueInvoice)
            expect(posToNeg(sourceInvoice.netTotal)).to.equal(creditInvoice.netTotal)

            //expect(sourceLicence.id).to.equal(creditLicence.id)
            expect(sourceLicence.licenceNumber).to.equal(creditLicence.licenceNumber)
            expect(posToNeg(sourceLicence.netTotal)).to.equal(creditLicence.netTotal)

            expect(sourceTransactions.clientId).to.equal(creditTransactions.clientId)
            expect(sourceTransactions.chargeValue).to.equal(creditTransactions.chargeValue)
            expect(sourceTransactions.credit).to.equal(false)
            expect(sourceTransactions.lineDescription).to.equal(creditTransactions.lineDescription)
            expect(sourceTransactions.periodStart).to.equal(creditTransactions.periodStart)
            expect(sourceTransactions.periodEnd).to.equal(creditTransactions.periodEnd)
            expect(sourceTransactions.compensationCharge).to.equal(creditTransactions.compensationCharge)
            expect(sourceTransactions.calculation).to.deep.equal(creditTransactions.calculation)
          })
        })
      })
    })
  })
})

And('the rebill R invoice includes all transactions', () => {
  cy.get('@sourceBillRun').then((sourceBillRun) => {
    const originalBillRun = sourceBillRun
    const originalInvoice = sourceBillRun.invoices[0]

    cy.get('@destinationBillRun').then((destinationBillRun) => {
      const destinationBillRun1 = destinationBillRun.body.billRun
      cy.get('@rebillResponse').then((response) => {
        const rebillInvoice = response.body.invoices[1]

        InvoiceEndpoints.view(originalBillRun.id, originalInvoice.id, false).then((response1) => {
          const sourceInvoice = response1.body.invoice
          const sourceLicence = sourceInvoice.licences[0]
          const sourceTransactions = sourceLicence.transactions[0]
          InvoiceEndpoints.view(destinationBillRun1.id, rebillInvoice.id, false).then((response3) => {
            const rebillInvoice = response3.body.invoice
            const rebillLicence = rebillInvoice.licences[0]
            const rebillTransactions = rebillLicence.transactions[0]

            cy.log('Testing source invoice transactions against rebill (C) credit invoice transactions')

            expect(sourceInvoice.ruleset).to.equal(rebillInvoice.ruleset)
            expect(sourceInvoice.customerReference).to.equal(rebillInvoice.customerReference)
            expect(sourceInvoice.financialYear).to.equal(rebillInvoice.financialYear)
            expect(sourceInvoice.deminimisInvoice).to.equal(rebillInvoice.deminimisInvoice)
            expect(sourceInvoice.zeroValueInvoice).to.equal(rebillInvoice.zeroValueInvoice)
            expect(sourceInvoice.netTotal).to.equal(rebillInvoice.netTotal)

            //expect(sourceLicence.id).to.equal(rebillLicence.id)
            expect(sourceLicence.licenceNumber).to.equal(rebillLicence.licenceNumber)
            expect(sourceLicence.netTotal).to.equal(rebillLicence.netTotal)

            expect(sourceTransactions.clientId).to.equal(rebillTransactions.clientId)
            expect(sourceTransactions.chargeValue).to.equal(rebillTransactions.chargeValue)
            expect(sourceTransactions.credit).to.equal(rebillTransactions.credit)
            expect(sourceTransactions.lineDescription).to.equal(rebillTransactions.lineDescription)
            expect(sourceTransactions.periodStart).to.equal(rebillTransactions.periodStart)
            expect(sourceTransactions.periodEnd).to.equal(rebillTransactions.periodEnd)
            expect(sourceTransactions.compensationCharge).to.equal(rebillTransactions.compensationCharge)
            expect(sourceTransactions.calculation).to.deep.equal(rebillTransactions.calculation)
          })
        })
      })
    })
  })
})

And('the credit C invoice includes the source invoice ID', () => {
  cy.get('@sourceBillRun').then((sourceBillRun) => {
    const originalInvoice = sourceBillRun.invoices[0]
    cy.get('@destinationBillRun').then((destinationBillRun) => {
      const destinationBillRun1 = destinationBillRun.body.billRun
      cy.get('@rebillResponse').then((response) => {
        const creditInvoice = response.body.invoices[0]
        InvoiceEndpoints.view(destinationBillRun1.id, creditInvoice.id, false).then((response2) => {
          const creditInvoice = response2.body.invoice
          expect(originalInvoice.id).to.equal(creditInvoice.rebilledInvoiceId)
        })
      })
    })
  })
})

And('the rebill R invoice includes the source invoice ID', () => {
  cy.get('@sourceBillRun').then((sourceBillRun) => {
    const originalInvoice = sourceBillRun.invoices[0]
    cy.get('@destinationBillRun').then((destinationBillRun) => {
      const destinationBillRun1 = destinationBillRun.body.billRun
      cy.get('@rebillResponse').then((response) => {
        const rebillInvoice = response.body.invoices[1]
        InvoiceEndpoints.view(destinationBillRun1.id, rebillInvoice.id, false).then((response) => {
          const rebillInvoice = response.body.invoice
          expect(originalInvoice.id).to.equal(rebillInvoice.rebilledInvoiceId)
        })
      })
    })
  })
})

And('the credit C transaction includes the source transaction ID', () => {
  cy.get('@sourceBillRun').then((sourceBillRun) => {
    const originalBillRun = sourceBillRun
    const originalInvoice = sourceBillRun.invoices[0]
    InvoiceEndpoints.view(originalBillRun.id, originalInvoice.id, false).then((response1) => {
      const sourceInvoice = response1.body.invoice
      const sourceLicence = sourceInvoice.licences[0]
      const sourceTransactions = sourceLicence.transactions[0]
      cy.get('@destinationBillRun').then((destinationBillRun) => {
        const destinationBillRun1 = destinationBillRun.body.billRun

        cy.get('@rebillResponse').then((response) => {
          const creditInvoice = response.body.invoices[0]
          InvoiceEndpoints.view(destinationBillRun1.id, creditInvoice.id, false).then((response2) => {
            const creditInvoice = response2.body.invoice
            const creditLicence = creditInvoice.licences[0]
            const creditTransactions = creditLicence.transactions[0]
            expect(sourceTransactions.id).to.equal(creditTransactions.rebilledTransactionId)
          })
        })
      })
    })
  })
})

And('the rebill R transaction includes the source transaction ID', () => {
  cy.get('@sourceBillRun').then((sourceBillRun) => {
    const originalBillRun = sourceBillRun
    const originalInvoice = sourceBillRun.invoices[0]
    InvoiceEndpoints.view(originalBillRun.id, originalInvoice.id, false).then((response1) => {
      const sourceInvoice = response1.body.invoice
      const sourceLicence = sourceInvoice.licences[0]
      const sourceTransactions = sourceLicence.transactions[0]
      cy.get('@destinationBillRun').then((destinationBillRun) => {
        const destinationBillRun1 = destinationBillRun.body.billRun
        cy.get('@rebillResponse').then((response) => {
          const rebillInvoice = response.body.invoices[1]
          InvoiceEndpoints.view(destinationBillRun1.id, rebillInvoice.id, false).then((response) => {
            const rebillInvoice = response.body.invoice
            const rebillLicence = rebillInvoice.licences[0]
            const rebillTransactions = rebillLicence.transactions[0]
            expect(sourceTransactions.id).to.equal(rebillTransactions.rebilledTransactionId)
          })
        })
      })
    })
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

And('I am told the source invoice has already been rebilled', () => {
  cy.get('@sourceBillRun').then((sourceBillRun) => {
    const rebillInvoice = sourceBillRun.invoices[0]
    cy.get('@rebillResponse').then((response) => {
      expect(response.body.message).to.equal(`Invoice ${rebillInvoice.id} has already been rebilled.`)
    })
  })
})

And('I am told a rebill cancel invoice cannot be rebilled', () => {
  cy.get('@sourceBillRun').then((sourceBillRun) => {
    const cancelInvoice = sourceBillRun.invoices[0]

    cy.get('@rebillResponse').then((response) => {
      expect(response.body.message).to.equal(`Invoice ${cancelInvoice.id} is a rebill cancel invoice and cannot be rebilled.`)
    })
  })
})

And('I request to delete the C rebill invoice', () => {
  cy.get('@destinationBillRun').then((destinationBillRun) => {
    const destinationBillRun1 = destinationBillRun.body.billRun
    cy.get('@rebillResponse').then((response) => {
      const cancelInvoice = response.body.invoices[0]
      InvoiceEndpoints.delete(destinationBillRun1.id, cancelInvoice.id).then((response) => {
        expect(response.status).to.be.equal(204)
        BillRunEndpoints.view(destinationBillRun1.id)
      })
    })
  })
})

And('I request to delete the R rebill invoice', () => {
  cy.get('@destinationBillRun').then((destinationBillRun) => {
    const destinationBillRun1 = destinationBillRun.body.billRun
    cy.get('@rebillResponse').then((response) => {
      const rebillInvoice = response.body.invoices[1]
      InvoiceEndpoints.delete(destinationBillRun1.id, rebillInvoice.id).then((response) => {
        expect(response.status).to.be.equal(204)
        BillRunEndpoints.view(destinationBillRun1.id)
      })
    })
  })
})

When('I try to rebill it again', () => {
  cy.get('@destinationBillRun').then((destinationBillRun) => {
    const destinationBillRun1 = destinationBillRun.body.billRun

    cy.get('@sourceBillRun').then((sourceBillRun) => {
      const rebillInvoice = sourceBillRun.invoices[0]

      InvoiceEndpoints.rebill(destinationBillRun1.id, rebillInvoice.id, false).then((response) => {
        cy.wrap(response).as('rebillResponse')
      })
    })
  })
})

And('I try to add a standard {word} transaction to rebill invoices', (ruleset) => {
  cy.get('@destinationBillRun').then((destinationBillRun) => {
    const destinationBillRun1 = destinationBillRun.body.billRun

    cy.fixture(`standard.${ruleset}.transaction`).then((fixture) => {
      fixture.customerReference = 'CM00000001'
      fixture.licenceNumber = 'LIC/NUM/CM02'
      TransactionEndpoints.create(destinationBillRun1.id, fixture, false).then(() => {
        BillRunEndpoints.view(destinationBillRun1.id).then((response) => {
          cy.wrap(response.body.billRun).as('destinationBillRun')
        })
      })
    })
  })
})

And('a new invoice is created', () => {
  cy.get('@destinationBillRun').then((destinationBillRun) => {
    BillRunEndpoints.view(destinationBillRun.id).then((response) => {
      const destinationBillRun1 = response.body.billRun

      const cancelInvoice = destinationBillRun1.invoices.find(element => element.rebilledType === 'C')
      const rebillInvoice = destinationBillRun1.invoices.find(element => element.rebilledType === 'R')
      const newInvoice = destinationBillRun1.invoices.find(element => element.rebilledType === 'O')

      const cancelLicence = cancelInvoice.licences[0].licenceNumber
      const rebillLicence = rebillInvoice.licences[0].licenceNumber
      const newLicence = newInvoice.licences[0].licenceNumber

      expect(cancelLicence).to.not.equal('LIC/NUM/CM02')
      expect(rebillLicence).to.not.equal('LIC/NUM/CM02')
      expect(newLicence).to.equal('LIC/NUM/CM02')
    })
  })
})

And('I request to send the rebill bill run', () => {
  cy.get('@destinationBillRun').then((billRun) => {
    const destinationBillRun = billRun.body.billRun
    const destinationBillRunId = destinationBillRun.id

    BillRunEndpoints.generate(destinationBillRunId).then(() => {
      BillRunEndpoints.pollForStatus(destinationBillRunId, 'generated').then(() => {
        BillRunEndpoints.approve(destinationBillRunId).then(() => {
          BillRunEndpoints.send(destinationBillRunId).then((response) => {
            BillRunEndpoints.pollForStatus(destinationBillRunId, 'billed')
            expect(response.status).to.be.equal(204)
            BillRunEndpoints.view(destinationBillRunId).then((billRun) => {
              const sentbillRun = billRun.body.billRun
              expect(sentbillRun.transactionFileReference).to.not.be.equal(null)
            })
          })
        })
      })
    })
  })
})
