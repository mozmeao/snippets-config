#!/bin/bash

set -ex pipefail

NEWRELIC_USER=gitlab

API_KEY=$(< ~/.newrelic-api-key)

# the image value in the yaml contains the first 7 digits of the git commit hash
# yaml line format is as follows:
# image: mozorg/snippets:283065b
GIT_COMMIT_SHORT="$(grep -oP '(image: .+?:)\K.*' ${DEPLOYMENT}/web.yaml)"

# go tell new relic
curl -s -H "x-api-key:${API_KEY}" \
     -d "deployment[app_name]=${NEWRELIC_APP}" \
     -d "deployment[revision]=${GIT_COMMIT_SHORT}" \
     -d "deployment[user]=${NEWRELIC_USER}" \
     https://api.newrelic.com/deployments.xml
