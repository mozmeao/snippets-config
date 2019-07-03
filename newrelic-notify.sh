#!/bin/bash

set -ex pipefail

NEWRELIC_USER=gitlab
# TODO: where/how to get newrelic api key?
# retrieve from somewhere on disk or a service?
API_KEY=$(< ~/.newrelic-api-key)

# get the image value from the base deployment matching the K8S_NAMESPACE
FULL_IMAGE="kubectl get deploy ${K8S_NAMESPACE} -n ${K8S_NAMESPACE} -o jsonpath=\"{$.spec.template.spec.containers[0].image}\""

# last 7 characters of the image value will be the hash
GIT_COMMIT_SHORT="${FULL_IMAGE: -7}"

# go tell new relic
curl -s -H "x-api-key:${API_KEY}" \
     -d "deployment[app_name]=${NEWRELIC_APP}" \
     -d "deployment[revision]=${GIT_COMMIT_SHORT}" \
     -d "deployment[user]=${NEWRELIC_USER}" \
     https://api.newrelic.com/deployments.xml
