#!/bin/bash

set -a
source .env.sample
set +a

function _start_postgres() {
  if docker ps --filter "name=${APP_NAME}-postgres" --filter "status=running" --quiet | grep -q .; then
    echo "Container \"${APP_NAME}-postgres\" is running."
  else
    echo "Starting \"${APP_NAME}-postgres\" container..."

    # Start the postgres container
    docker run --name ${APP_NAME}-postgres \
        -p 5432:5432 \
        -e POSTGRES_DB="${DB_NAME}" \
        -e POSTGRES_USER="${DB_USERNAME}" \
        -e POSTGRES_PASSWORD="${DB_PASSWORD}" \
        -d postgres

    # Wait for the postgres container to be ready
    sleep 10
  fi
}