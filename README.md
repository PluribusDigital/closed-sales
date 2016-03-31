## Dependencies

Foundation
`npm install -g foundation-cli bower gulp`
(see http://foundation.zurb.com/apps/getting-started.html)

## Front end Development

```shell
vagrant up
vagrant ssh
./run-www.sh
```

Changes made to the `public/app` directory should automatically be detected and presented on a browser refresh

## Process

### Setup Rails App

* Install gems: pg

### Scrape the Data

* Mechanize gem
* Write Scraper
* For Prototype: store data to file
* Use db seed for easy collaboration

### Setup Front End

* Setup Foundation in public/app
* For Prototype: keep in public, but can be moved as needed for prod

## Build API

* Generate model `rails g model loan sale_id:string site_name:string date_sold:date loan_type:string quality:string number_of_loans:integer book_value:integer sales_price:integer winning_bidder:string address:string`
* Generate controller `rails g controller loans`
* Setup JSONAPI (https://github.com/doga/jsonapi_for_rails)

* Write API tests
* Test read
* Test read only (not delete/post/patch)

