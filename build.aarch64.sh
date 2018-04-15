#!/usr/bin/env bash

docker_compose="/usr/local/bin/docker-compose -f docker-compose.aarch64.yml"

${docker_compose} stop &&
${docker_compose} rm -f &&
${docker_compose} pull &&
${docker_compose} build --no-cache &&
${docker_compose} up -d --force-recreate