
// <reference types="cypress" />

describe('My First Test', () => {
    it('Flutter login',  () => { 
        cy.visit("https://screen.amlcloud.io/#/login", {timeout: 30000})
        // verify the title of the page "Sanctions Screener"
        cy.title().should('eq', "Sanctions Screener")
        // verify current url 
        cy.url().should('include', 'amlcloud') // => true
        cy.get('flt-semantics-placeholder').first().click({ force: true });
        // Clicking on Log In Anonymous
        cy.get('flt-semantics[aria-label="Log in Anonymous"]').click({ force: true });
        cy.get('flt-semantics input').type('Hello, AML Cloud')
         cy.get('flt-semantics[aria-label="Search"]').click()
        cy.wait(10000); // waiting for some time  
    })
  }) 