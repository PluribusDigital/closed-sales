@javascript
Feature: Global Text Search
  In order to search through the loan records,
  you can simply enter in any full or partial phrase
  and see all records that match that text
  in any field.

  Scenario: Match an address
    Given I am on the 'home' page
    When I fill in Houston, TX for 'searchText'
    Then The result set should have 5 records

  Scenario: Match a sale id
    Given I am on the 'home' page
    When I fill in 94CM for 'searchText' 
    Then The result set should have 3 records

  