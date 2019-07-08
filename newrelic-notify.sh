#!/bin/bash

set -ex pipefail

NEWRELIC_USER=gitlab

API_KEY=$(< ~/.newrelic-api-key)

# last 7 characters of the image value will be the hash
GIT_COMMIT_SHORT="grep -oP '(image: .+?:)\K.*' ${DEPLOYMENT}/web-deploy.yaml"

# go tell new relic
curl -s -H "x-api-key:${API_KEY}" \
     -d "deployment[app_name]=${NEWRELIC_APP}" \
     -d "deployment[revision]=${GIT_COMMIT_SHORT}" \
     -d "deployment[user]=${NEWRELIC_USER}" \
     https://api.newrelic.com/deployments.xml
