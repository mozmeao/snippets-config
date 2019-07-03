#!/bin/bash

set -ex pipefail

NEWRELIC_USER=gitlab
# TODO: where/how to get newrelic api key?
# retrieve from somewhere on disk or a service?
API_KEY=idunno

if [[ $NEWRELIC_APP = snippets-dev-oregon-b ]]; then
    K8S_NAMESPACE=snippets-dev
elif [[ $NEWRELIC_APP = snippets-stage-oregon-b ]]; then
    K8S_NAMESPACE=snippets-stage
elif [[ $NEWRELIC_APP = snippets-prod-frankfurt ]]; then
    K8S_NAMESPACE=snippets-prod
fi

# set the namespace before getting the deployment
kubectl config set-context $(kubectl config current-context) --namespace=$K8S_NAMESPACE

# get the image value from the base deployment matching the K8S_NAMESPACE
FULL_IMAGE="kubectl get deploy ${K8S_NAMESPACE} -o jsonpath=\"{...image}\""

# last 7 characters of the image value will be the hash
GIT_COMMIT_SHORT="${FULL_IMAGE: -7}"

# go tell new relic
curl -s -H "x-api-key:${API_KEY}" \
     -d "deployment[app_name]=${NEWRELIC_APP}" \
     -d "deployment[revision]=${GIT_COMMIT_SHORT}" \
     -d "deployment[user]=${NEWRELIC_USER}" \
     https://api.newrelic.com/deployments.xml
