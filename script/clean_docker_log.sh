#!/bin/bash

Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
UBlue='\033[4;34m'
Plain='\033[0m'

echo -e "${Green}======== Start Cleaning Docker Containers Logs ========${Plain}\n"
logs=$(find /var/lib/docker/containers/ -name '*-json.log')
for log in $logs
  do
    echo -e "Log Cleaned: $log\n"
    cat /dev/null > $log
  done
echo -e "${Yellow}=========== Docker Containers Logs Cleaned ===========${Plain}\n"
