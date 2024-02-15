#!/bin/sh

set -o errexit
set -o noglob
set -o nounset

if test "${INPUT_CHECK}" == "certificate"; then
###############################################
# Certificate Check
###############################################

  # input handling
  PARAM_EXPIRATION_THRESHOLD="--expiration-threshold=5"
  if ! test -z "${INPUT_EXPIRATION_THRESHOLD:-}"; then
    PARAM_EXPIRATION_THRESHOLD="--expiration-threshold=${INPUT_EXPIRATION_THRESHOLD}"
  fi

  PARAM_FINGERPRINT=""
  if ! test -z "${INPUT_FINGERPRINT:-}"; then
    PARAM_FINGERPRINT="--fingerprint=${INPUT_FINGERPRINT}"
  fi

  PARAM_SERIAL_NUMBER=""
  if ! test -z "${INPUT_SERIAL_NUMBER:-}"; then
    PARAM_SERIAL_NUMBER="--fingerprint=${INPUT_SERIAL_NUMBER}"
  fi

  PARAM_ISSUER_NAME=""
  if ! test -z "${INPUT_ISSUER_NAME:-}"; then
    PARAM_ISSUER_NAME="--issuer-name=${INPUT_ISSUER_NAME}"
  fi

  # check execution
  # shellcheck disable=SC2086,SC2090
  watchr \
    check:certificate \
    --no-ansi \
    -vvv \
    $PARAM_EXPIRATION_THRESHOLD \
    $PARAM_FINGERPRINT \
    $PARAM_SERIAL_NUMBER \
    $PARAM_ISSUER_NAME \
    -- \
    "${INPUT_DOMAIN}" > certificate.log 2>&1 \
    && EXIT_CODE=$? || EXIT_CODE=$?

  STDOUT=$(cat certificate.log)

elif test "${INPUT_CHECK}" == "domain"; then
############################################
# Domain Name Check
############################################

  # input handling
  PARAM_EXPIRATION_THRESHOLD="--expiration-threshold=5"
  if ! test -z "${INPUT_EXPIRATION_THRESHOLD:-}"; then
    PARAM_EXPIRATION_THRESHOLD="--expiration-threshold=${INPUT_EXPIRATION_THRESHOLD}"
  fi

  PARAM_REGISTRAR_NAME=""
  if ! test -z "${INPUT_REGISTRAR_NAME:-}"; then
    PARAM_REGISTRAR_NAME="--registrar-name=${INPUT_REGISTRAR_NAME}"
  fi

  PARAM_STATUS_CODES=""
  if ! test -z "${INPUT_STATUS_CODES:-clientTransferProhibited}"; then
    IFS=','
    for CODE in ${INPUT_STATUS_CODES:-clientTransferProhibited}; do
      PARAM_STATUS_CODES="${PARAM_STATUS_CODES} --status-codes=${CODE}"
    done;
  fi

  # check execution
  IFS=' '
  # shellcheck disable=SC2086,SC2090
  watchr \
    check:domain \
    --no-ansi \
    -vvv \
    $PARAM_EXPIRATION_THRESHOLD \
    $PARAM_REGISTRAR_NAME \
    $PARAM_STATUS_CODES \
    -- \
    "${INPUT_DOMAIN}" > domain.log 2>&1 \
    && EXIT_CODE=$? || EXIT_CODE=$?

  STDOUT=$(cat domain.log)

elif test "${INPUT_CHECK}" == "http-resp"; then
###############################################
# HTTP Response Check
###############################################

  # input handling
  PARAM_METHOD=""
  if ! test -z "${INPUT_HTTP_METHOD:-}"; then
    PARAM_METHOD="--method=${INPUT_HTTP_METHOD}"
  fi

  PARAM_STATUS_CODES=""
  if ! test -z "${INPUT_HTTP_STATUS_CODES:-}"; then
    IFS=','
    for CODE in ${INPUT_HTTP_STATUS_CODES}; do
      PARAM_STATUS_CODES="${PARAM_STATUS_CODES} --status-code=${CODE}"
    done;
  fi

  # check execution
  IFS=' '
  # shellcheck disable=SC2086,SC2090
  watchr \
    check:http-resp \
    --no-ansi \
    -vvv \
    $PARAM_METHOD \
    $PARAM_STATUS_CODES \
    -- \
    "${INPUT_HTTP_TARGET_URL}" > http.log 2>&1 \
    && EXIT_CODE=$? || EXIT_CODE=$?
else
  echo "Invalid check value \"{$INPUT_CHECK}\""

  exit 1
fi

echo "status=${EXIT_CODE}" >> "$GITHUB_OUTPUT"
{
  echo "stdout<<EOSTDOUT"
  echo "${STDOUT}"
  echo "EOSTDOUT"
} >> "$GITHUB_OUTPUT"
echo "${STDOUT}" >> "$GITHUB_STEP_SUMMARY"

exit "${EXIT_CODE}"
