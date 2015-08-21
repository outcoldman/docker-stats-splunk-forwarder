#!/bin/bash

DOCKER_BIN=$(dirname "$0")/docker
"$DOCKER_BIN" stats --no-stream=true $("$DOCKER_BIN" ps -q) \
  | tail -n +2 \
  | grep -Ev "\w+\s+0\.00%\s+0\sB/0\sB\s+0\.00%\s+0\sB/0\sB" \
  | sed 's/\//  /g' \
  | awk -F '[[:space:]][[:space:]]+' '{print $1","$2","$3","$4","$5","$6","$7}'
