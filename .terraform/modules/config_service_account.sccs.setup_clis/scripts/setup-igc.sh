#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"

OSTYPE=$(uname)
if [[ "$OSTYPE" == "Linux" ]]; then
  TYPE=$(cat /etc/os-release | grep -E "^ID=" | sed "s/ID=//g")
  if [[ "${TYPE}" != "alpine" ]]; then
    TYPE="linux"
  fi
elif [[ "$OSTYPE" == "Darwin" ]]; then
  TYPE="macos"
else
  echo "OS not supported"
  exit 1
fi

if [[ -f "${DEST_DIR}/.igc-release" ]]; then
  RELEASE=$(cat "${DEST_DIR}/.igc-release")
else
  RELEASE=$(curl -s "https://api.github.com/repos/cloud-native-toolkit/ibm-garage-cloud-cli/releases/latest" | "${DEST_DIR}/jq" -r '.tag_name')
  echo -n "${RELEASE}" > "${DEST_DIR}/.igc-release"
fi

"${SCRIPT_DIR}/setup-binary.sh" "${DEST_DIR}" igc "https://github.com/cloud-native-toolkit/ibm-garage-cloud-cli/releases/download/${RELEASE}/igc-${TYPE}"
