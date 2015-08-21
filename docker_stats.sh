#!/bin/bash

DOCKER_BIN=$(dirname "$0")/docker
"$DOCKER_BIN" stats --no-stream=true $("$DOCKER_BIN" ps -q) | tail -n +2
