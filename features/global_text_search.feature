Feature: Global Text Search
  In order to search through the loan records,
  you can simply enter in any full or partial phrase
  and see all records that match that text
  in any field.

  @javascript
  Scenario: Match an address
    Given I am on the 'home' page
    When I fill in 'Houston, TX' for 'searchText'
    Then I should see text 'Showing 1 to 5 of 5 entries'

  @javascript
  Scenario: Match a loan type
    Given I am on the 'home' page
    When I fill in 'Other' for 'searchText' 
    Then I should see text 'Showing 1 to 3 of 3 entries'