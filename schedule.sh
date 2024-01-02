#!/bin/bash

# Wipe existing jobs to avoid conflicts
crontab -r

# dbt run
dbt_run="0 0 */2 * * docker run --env-file /home/circleci/.env --network=host --mount type=bind,source=/home/circleci/scopuli/ganymede/,target=/usr/app --mount type=bind,source=/home/circleci/scopuli/,target=/root/.dbt/ ghcr.io/dbt-labs/dbt-postgres:1.5.2 run --target prod"

# scrapy jobs
loblaws_white_onion="0 0 */7 * * docker exec -u0 aethervest-crawler-1 bash -c \"source venv/bin/activate && cd loblaws && xvfb-run scrapy crawl white_onion\""
loblaws_search_results="0 */12 */2 * * docker exec -u0 aethervest-crawler-1 bash -c \"source venv/bin/activate && cd loblaws && xvfb-run scrapy crawl search_results\""

# load StatCan resources
statcan_cpi_monthly="0 0 1 */1 * python aethervest/statcan/cpi_monthly_1810000401/loader.py"
statcan_food_prices="0 0 1 */1 * python aethervest/statcan/food_prices_1810024501/loader.py"

# Create a temporary file to store the cron job entries
temp_file=$(mktemp)

echo "$dbt_run" >> "$temp_file"
echo "$cmd_1" >> "$temp_file"
echo "$statcan_cpi_monthly" >> "$temp_file"
echo "$statcan_food_prices" >> "$tmp_file"

# Load the temporary file as the new crontab
crontab "$temp_file"

# Remove the temporary file
rm "$temp_file"