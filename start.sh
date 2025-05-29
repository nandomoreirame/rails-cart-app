#!/bin/bash

set -a
source .env.sample
set +a

source ./docker-run.sh

_start_postgres

# Run the rails server
cd ./${APP_NAME}

bundle install
bundle exec rails db:migrate
bundle exec rails db:seed
bundle exec rails s -p 3000 -b '0.0.0.0'