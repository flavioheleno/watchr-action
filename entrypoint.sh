#!/bin/sh

set -o errexit
set -o noglob
set -o nounset

if test "${INPUT_CHECK}" == "certificate"; then
  PARAM_EXPIRATION_THRESHOLD="--expiration-threshold=5"
  if ! test -z "${INPUT_EXPIRATION_THRESHOLD}"; then
    PARAM_EXPIRATION_THRESHOLD="--expiration-threshold=${INPUT_EXPIRATION_THRESHOLD}"
  fi

  PARAM_FINGERPRINT="--skip-fingerprint"
  if ! test -z "${INPUT_FINGERPRINT}"; then
    PARAM_FINGERPRINT="--fingerprint=\"${INPUT_FINGERPRINT}\""
  fi

  PARAM_SERIAL_NUMBER="--skip-serial-number"
  if ! test -z "${INPUT_SERIAL_NUMBER}"; then
    PARAM_SERIAL_NUMBER="--fingerprint=\"${INPUT_SERIAL_NUMBER}\""
  fi

  PARAM_ISSUER_NAME="--skip-issuer-name"
  if ! test -z "${INPUT_ISSUER_NAME}"; then
    PARAM_ISSUER_NAME="--issuer-name=\"${INPUT_ISSUER_NAME}\""
  fi

  STDOUT=$(
    watchr \
      check:certificate \
      -vvv \
      "${PARAM_EXPIRATION_THRESHOLD}" \
      "${PARAM_FINGERPRINT}" \
      "${PARAM_SERIAL_NUMBER}" \
      "${PARAM_ISSUER_NAME}" \
      -- \
      "${INPUT_DOMAIN}"
  )

  # shellcheck disable=SC2086
  echo "status=$?" >> $GITHUB_OUTPUT
  # shellcheck disable=SC2086
  echo "stdout=${STDOUT}" >> $GITHUB_OUTPUT
elif test "${INPUT_CHECK}" == "domain"; then
  PARAM_EXPIRATION_THRESHOLD="--expiration-threshold=5"
  if ! test -z "${INPUT_EXPIRATION_THRESHOLD}"; then
    PARAM_EXPIRATION_THRESHOLD="--expiration-threshold=${INPUT_EXPIRATION_THRESHOLD}"
  fi

  PARAM_REGISTRAR_NAME="--skip-registrar-name"
  if ! test -z "${INPUT_REGISTRAR_NAME}"; then
    PARAM_REGISTRAR_NAME="--registrar-name=\"${INPUT_REGISTRAR_NAME}\""
  fi

  STDOUT=$(
    watchr \
      check:domain \
      -vvv \
      "${PARAM_EXPIRATION_THRESHOLD}" \
      "${PARAM_REGISTRAR_NAME}" \
      -- \
      "${INPUT_DOMAIN}"
  )

  # shellcheck disable=SC2086
  echo "status=$?" >> $GITHUB_OUTPUT
  # shellcheck disable=SC2086
  echo "stdout=${STDOUT}" >> $GITHUB_OUTPUT
else
  echo "Invalid check value \"{$INPUT_CHECK}\""

  exit 1
fi
