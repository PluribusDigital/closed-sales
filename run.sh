#!/bin/sh

gulp --cwd $STATIC &
bundle exec rails server -b 0.0.0.0

wait