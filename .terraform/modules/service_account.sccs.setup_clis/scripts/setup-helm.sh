#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"

CLI_NAME="helm"
URL="https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz"
TGZ_PATH="linux-amd64/helm"

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" "${CLI_NAME}" "${URL}" "${TGZ_PATH}"
