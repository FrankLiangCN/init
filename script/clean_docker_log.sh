#!/bin/bash
echo -e "======== start clean docker containers logs ========\n"
logs=$(find /var/lib/docker/containers/ -name '*-json.log')
for log in $logs
  do
    echo -e "clean logs : $log\n"
    cat /dev/null > $log
  done
echo -e "======== end clean docker containers logs ========\n"
