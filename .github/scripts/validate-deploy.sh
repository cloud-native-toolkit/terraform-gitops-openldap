#!/usr/bin/env bash

GIT_REPO=$(cat git_repo)
GIT_TOKEN=$(cat git_token)

export KUBECONFIG=$(cat .kubeconfig)
NAMESPACE=$(cat .namespace)

# Find the my mobule
COMPONENT_NAME="openldap"


count=0
until kubectl get namespace "${NAMESPACE}" 1> /dev/null 2> /dev/null || [[ $count -eq 20 ]]; do
  echo "Waiting for namespace: ${NAMESPACE}"
  count=$((count + 1))
  sleep 15
done

if [[ $count -eq 20 ]]; then
  echo "Timed out waiting for namespace: ${NAMESPACE}"
  exit 1
else
  echo "Found namespace: ${NAMESPACE}. Sleeping for 30 seconds to wait for everything to settle down"
  sleep 30
fi

DEPLOYMENT="${COMPONENT_NAME}"
count=0
until kubectl get deployment "${DEPLOYMENT}" -n "${NAMESPACE}" || [[ $count -eq 20 ]]; do
  echo "Waiting for deployment/${DEPLOYMENT} in ${NAMESPACE}"
  count=$((count + 1))
  sleep 15
done

# List all parameters

if [[ $count -eq 20 ]]; then
  echo "Timed out waiting for deployment/${DEPLOYMENT} in ${NAMESPACE}"
  kubectl get all -n "${NAMESPACE}"
  exit 1
fi

kubectl rollout status "deployment/${DEPLOYMENT}" -n "${NAMESPACE}" || exit 1

cd ..
rm -rf .testrepo
