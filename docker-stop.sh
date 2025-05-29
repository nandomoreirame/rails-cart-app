#!/bin/bash

set -a
source .env.sample
set +a

docker stop ${APP_NAME}-postgres
docker rm ${APP_NAME}-postgres