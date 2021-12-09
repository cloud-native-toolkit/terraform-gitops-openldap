#!/usr/bin/env bash

DEST_DIR="$1"
CLI_NAME="$2"
CLI_URL="$3"
CLI_PATH="$4"

mkdir -p "${DEST_DIR}"

BIN_DIR=$(cd "${DEST_DIR}"; pwd -P)

if command -v "${BIN_DIR}/${CLI_NAME}" 1> /dev/null 2> /dev/null; then
  echo "${CLI_NAME} already installed in ${BIN_DIR}..."
  exit 0
fi

COMMAND=$(command -v "${CLI_NAME}")

if [[ -n "${COMMAND}" ]]; then
  echo "${CLI_NAME} already installed. Linking to ${BIN_DIR}"
  ln -s "${COMMAND}" "${BIN_DIR}/${CLI_NAME}"
  COMMAND="${BIN_DIR}/${CLI_NAME}"
else
  TAR_FILE="${BIN_DIR}/${CLI_NAME}.tgz"

  if [[ -f "${TAR_FILE}" ]]; then
    echo "${CLI_NAME} is already being installed. Waiting..."

    while [[ -f "${TAR_FILE}" ]]; do
      sleep 10
    done
  else
    echo "${CLI_NAME} missing. Installing..."
    touch "${TAR_FILE}"

    curl -sLo "${TAR_FILE}" "${CLI_URL}"

    if [[ ! -f "${BIN_DIR}/${CLI_NAME}" ]]; then
      tar xzf "${TAR_FILE}" "${CLI_PATH}"
      cp "${CLI_PATH}" "${BIN_DIR}/${CLI_NAME}"
      rm "${CLI_PATH}"
    fi

    rm "${TAR_FILE}"
    chmod +x "${BIN_DIR}/${CLI_NAME}"
  fi

  COMMAND="${BIN_DIR}/${CLI_NAME}"
fi
