#!/usr/bin/env bash

docker_compose="/usr/local/bin/docker-compose -f docker-compose-dev.yml"

${docker_compose} stop &&
${docker_compose} rm -f --all &&
${docker_compose} pull &&
${docker_compose} build --no-cache &&
${docker_compose} up -d --force-recreate
