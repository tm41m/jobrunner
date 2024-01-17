#!/bin/bash

target_job="0 0 */2 * * docker run --env-file /home/circleci/.env --network=host --mount type=bind,source=/home/circleci/jobrunner/scopuli/ganymede/,target=/usr/app --mount type=bind,source=/home/circleci/jobrunner/scopuli/,target=/root/.dbt/ ghcr.io/dbt-labs/dbt-postgres:1.5.2 run --target prod"

crontab_content=$(crontab -l)

if [[ $crontab_content == *"$target_job"* ]]; then
    echo "Correct pathing"
else
    echo "Error, incorrect pathing"
fi
