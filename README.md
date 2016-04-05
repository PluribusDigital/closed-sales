## Prerequisites

###### Rails Development
+ [Foundation](http://foundation.zurb.com/apps/getting-started.html)

###### Front-end Development
+ [Vagrant](https://www.vagrantup.com/downloads.html)
* [(optional) Update VirtualBox Guest Additions](https://github.com/dotless-de/vagrant-vbguest)
  * `vagrant plugin install vagrant-vbguest`

---

## Front-end Development

##### First-Time
1. Set up the environment variables

 ```shell
 cp .env.example .env
 ```

2. Open `.env` in your favorite text editor and fill in the appropriate values
3. Initialize the database

 ```shell
 vagrant up
 vagrant ssh
 docker-compose up -d
 docker-compose run api rake db:create db:migrate db:seed
 ```

##### Every other time

```shell
vagrant up
vagrant ssh
docker-compose up
```

Changes made to the `public/app/client` directory should automatically be detected and presented on a browser refresh

---

## The Process we Followed To Get to this Repo

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

