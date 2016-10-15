@javascript
Feature: Advanced Filters
  In order to search through the loan records,
  I want to be able to filter on specific values and ranges

  Scenario: Filter on book value (low)
    Given I am on the 'home' page
      And I select the 'Filter' button
     When I fill in 14045360 for 'Book Value Low'
     Then The result set should have 2 records

  Scenario: Filter on book value (high)
    Given I am on the 'home' page
      And I select the 'Filter' button
     When I fill in 120000 for 'Book Value High'
     Then The result set should have 2 records

  Scenario Outline: Match multiple filter combinations
    Given I am on the 'home' page
      And I select the 'Filter' button
     When I select <quality> for 'quality'
      And I select <loan_type> for 'loan_type'
      And I fill in <book_value_low> for 'Book Value Low'
      And I fill in <book_value_high> for 'Book Value High'
      And I fill in <sales_price_low> for 'Sales Price Low'
      And I fill in <sales_price_high> for 'Sales Price High'
      And I fill in <date_sold_low> for 'Date Sold Low'
      And I fill in <date_sold_high> for 'Date Sold High'
     Then The result set should have <results> records

  Examples:
      | quality    | loan_type | book_value_low | book_value_high | sales_price_low | sales_price_high | date_sold_low | date_sold_high | results |
      | Performing |           |                |                 |                 |                  |               |                | 13      |
      |            | Other     |                |                 |                 |                  |               |                | 3       |
      | Performing | Other     |                |                 |                 |                  |               |                | 1       |
      | Performing |           | 14045360       |                 |                 |                  |               |                | 1       |
      |            |           | 10000000       |                 | 10000000        |                  |               |                | 1       |
      |            |           |                |                 | 130000          | 160000           |               |                | 2       |

      
