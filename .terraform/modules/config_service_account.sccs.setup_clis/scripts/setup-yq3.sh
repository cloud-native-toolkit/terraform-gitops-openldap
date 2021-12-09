#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"

OSTYPE=$(uname)
if [[ "$OSTYPE" == "Linux" ]]; then
  URL="https://github.com/mikefarah/yq/releases/download/3.4.1/yq_linux_amd64"
elif [[ "$OSTYPE" == "Darwin" ]]; then
  URL="https://github.com/mikefarah/yq/releases/download/3.4.1/yq_darwin_amd64"
else
  echo "OS not supported"
  exit 1
fi

"${SCRIPT_DIR}/setup-binary.sh" "${DEST_DIR}" yq3 "${URL}"
