#!/bin/sh

set -o errexit
set -o noglob
set -o nounset

if test "${INPUT_CHECK}" == "certificate"; then
  PARAM_EXPIRATION_THRESHOLD="--expiration-threshold=5"
  if ! test -z "${INPUT_EXPIRATION_THRESHOLD}"; then
    PARAM_EXPIRATION_THRESHOLD="--expiration-threshold=${INPUT_EXPIRATION_THRESHOLD}"
  fi

  PARAM_FINGERPRINT=""
  if ! test -z "${INPUT_FINGERPRINT}"; then
    PARAM_FINGERPRINT="--fingerprint=\"${INPUT_FINGERPRINT}\""
  fi

  PARAM_SERIAL_NUMBER=""
  if ! test -z "${INPUT_SERIAL_NUMBER}"; then
    PARAM_SERIAL_NUMBER="--fingerprint=\"${INPUT_SERIAL_NUMBER}\""
  fi

  PARAM_ISSUER_NAME=""
  if ! test -z "${INPUT_ISSUER_NAME}"; then
    PARAM_ISSUER_NAME="--issuer-name=\"${INPUT_ISSUER_NAME}\""
  fi

  STDOUT=$(
    watchr \
      check:certificate \
      -vvv \
      $PARAM_EXPIRATION_THRESHOLD \
      $PARAM_FINGERPRINT \
      $PARAM_SERIAL_NUMBER \
      $PARAM_ISSUER_NAME \
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

  PARAM_REGISTRAR_NAME=""
  if ! test -z "${INPUT_REGISTRAR_NAME}"; then
    PARAM_REGISTRAR_NAME="--registrar-name=\"${INPUT_REGISTRAR_NAME}\""
  fi

  PARAM_STATUS_CODES=""
  if ! test -z "${INPUT_STATUS_CODES}"; then
    CODE_ARR=()
    CODE_STR="${INPUT_STATUS_CODES},"
    while [[ $CODE_STR ]]; do
      CODE_ARR+=( "${CODE_STR%%","*}" )
      CODE_STR=${CODE_STR#*","}
    done

    for CODE in "${CODE_ARR[@]}"; do
      PARAM_STATUS_CODES="${PARAM_STATUS_CODES} --status-codes=${CODE}"
    done;
  fi

  STDOUT=$(
    watchr \
      check:domain \
      -vvv \
      $PARAM_EXPIRATION_THRESHOLD \
      $PARAM_REGISTRAR_NAME \
      $PARAM_STATUS_CODES \
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
