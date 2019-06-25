#!/bin/bash

set -eu

if [ -n "${SONAR_TOKEN:-}" ]; then
  SONAR_OPTS="${SONAR_OPTS} -D sonar.login=${SONAR_TOKEN}"
fi

if [ -n "${SONAR_HOST:-}" ]; then
  SONAR_OPTS="${SONAR_OPTS} -D sonar.host.url=${SONAR_HOST}"
fi

if [ -n "${SONAR_PROJECT_KEY:-}" ] then
  SONAR_OPTS="${SONAR_OPTS} -d sonar.projectKey=${SONAR_PROJECT_KEY}"
fi

if [ -n "${SONAR_SOURCES:-}" ] then
  SONAR_OPTS="${SONAR_OPTS} -d sonar.sources=${SONAR_SOURCES}"
fi

if [ -n "${SONAR_ORGANIZATION:-}" ] then
  SONAR_OPTS="${SONAR_OPTS} -d sonar.organization=${SONAR_ORGANIZATION}"
fi

if [ -n "${CIRCLE_SHA1:-}" ]; then
  SONAR_OPTS="${SONAR_OPTS} -D sonar.projectVersion=${CIRCLE_SHA1}"
fi

if [ -n "${CIRCLE_PR_NUMBER:-}" ]; then
  SONAR_OPTS="${SONAR_OPTS} -D sonar.analysis.mode=preview -D sonar.pullrequest.key=${CIRCLE_PR_NUMBER}"
fi

if [ -n "${CIRCLE_REPOSITORY_URL:-}" ]; then
  SONAR_OPTS="${SONAR_OPTS} -D sonar.links.scm=${CIRCLE_REPOSITORY_URL}"
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