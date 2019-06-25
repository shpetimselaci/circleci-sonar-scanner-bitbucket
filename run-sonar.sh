#!/bin/bash

set -eu

if [ -n "${SONAR_TOKEN:-}" ]; then
    SONAR_OPTS="${SONAR_OPTS} -D sonar.login=${SONAR_TOKEN}"
fi

if [ -n "${SONAR_HOST:-}" ]; then
    SONAR_OPTS="${SONAR_OPTS} -D sonar.host.url=${SONAR_HOST}"
fi

if [ -n "${SONAR_PROJECT_KEY:-}" ]; then
    SONAR_OPTS="${SONAR_OPTS} -D sonar.projectKey=${SONAR_PROJECT_KEY}"
fi

if [ -n "${SONAR_SOURCES:-}" ]; then
    SONAR_OPTS="${SONAR_OPTS} -D sonar.sources=${SONAR_SOURCES}"
fi

if [ -n "${SONAR_PROVIDER:-}" ]; then
    SONAR_OPTS="${SONAR_OPTS} -D sonar.scm.provider=${SONAR_PROVIDER}"
fi

if [ -n "${SONAR_ORGANIZATION:-}" ]; then
    SONAR_OPTS="${SONAR_OPTS} -D sonar.organization=${SONAR_ORGANIZATION}"
fi

if [ -n "${CIRCLE_SHA1:-}" ]; then
    SONAR_OPTS="${SONAR_OPTS} -D sonar.projectVersion=${CIRCLE_SHA1}"
fi

if [ -n "${CIRCLE_PR_NUMBER:-}" ]; then
    SONAR_OPTS="${SONAR_OPTS} -D sonar.analysis.mode=preview -D sonar.pullrequest.key=${CIRCLE_PR_NUMBER}"
fi

if [ -n "${SONAR_SOURCE_ENCODING:-}" ]; then
    SONAR_OPTS="${SONAR_OPTS} -D sonar.sourceEncoding=${SONAR_SOURCE_ENCODING}"
fi

if [ -n "${SONAR_JAVASCRIPT_FILE_SUFFIXES:-}" ]; then
    SONAR_OPTS="${SONAR_OPTS} -D sonar.javascript.file.suffixes=${SONAR_JAVASCRIPT_FILE_SUFFIXES}"
fi

if [ -n "${SONAR_LANGUAGE:-}" ]; then
    SONAR_OPTS="${SONAR_OPTS} -D sonar.language=${SONAR_LANGUAGE}"
fi

if [ -n "${SONAR_EXCLUSIONS:-}" ]; then
    SONAR_OPTS="${SONAR_OPTS} -D sonar.exclusions=${SONAR_EXCLUSIONS}"
fi

if [ -f 'package.json' ]; then
    NAME=$(cat package.json | grep \"name\": | head -1 | awk -F: '{ print $2 }' | sed 's/[",]//g' | tr -d '[[:space:]]')
    NAME="${NAME/@/}"
    NAME="${NAME/\//_}"
    SONAR_OPTS="${SONAR_OPTS} -D sonar.projectKey=${NAME}"
fi

if [ -n "${SONAR_OPTS:-}" ]; then
    sonar-scanner $SONAR_OPTS
else
    sonar-scanner
fi