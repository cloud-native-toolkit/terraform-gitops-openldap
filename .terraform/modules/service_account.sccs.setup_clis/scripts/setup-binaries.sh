#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
CLIS="$2"

if [[ "${CLIS}" =~ jq ]]; then
  "${SCRIPT_DIR}/setup-jq.sh" "${DEST_DIR}" || exit 1
fi

if [[ "${CLIS}" =~ igc ]]; then
  "${SCRIPT_DIR}/setup-igc.sh" "${DEST_DIR}" || exit 1
fi

if [[ "${CLIS}" =~ yq ]]; then
  "${SCRIPT_DIR}/setup-yq3.sh" "${DEST_DIR}" || exit 1
  "${SCRIPT_DIR}/setup-yq4.sh" "${DEST_DIR}" || exit 1
fi

if [[ "${CLIS}" =~ helm ]]; then
  "${SCRIPT_DIR}/setup-helm.sh" "${DEST_DIR}" || exit 1
fi
