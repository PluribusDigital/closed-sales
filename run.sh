#!/bin/sh

# let the DB launch
sleep 10

# build the DB
bundle exec rake db:create db:migrate db:seed

# run gulp & rails in parallel
gulp --cwd $STATIC &
bundle exec rails server -b 0.0.0.0
wait