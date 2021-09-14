import { Given } from 'cypress-cucumber-preprocessor/steps'
import CognitoEndpoints from '../../endpoints/cognito_endpoints'

Given('I am the {string} user', (user) => {
  CognitoEndpoints.create(user)
})
