#!/bin/bash

DOCKER_BIN=$(dirname "$0")/docker
for container_id in $("$DOCKER_BIN" ps -q); do
  command_date=$(date -u +%Y-%m-%dT%H:%M:%S%z)
  "$DOCKER_BIN" top $container_id \
    -Ao pid,ppid,pgid,pcpu,vsz,nice,etime,time,tty,ruser,user,rgroup,group,comm,args:1000 | \
    tail -n +2 | \
    sed -E 's/  +/,/g' | \
    awk "{print \"$command_date,$container_id,\"\$0}"
done
