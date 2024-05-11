#!/bin/bash

Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
UBlue='\033[4;34m'
Plain='\033[0m'

# 设置系统时区
# 获取当前时区
current_timezone=$(date +%Z)

# 判断当前时区是否为Asia/Hong_Kong
if [ "$current_timezone" != "HKT" ]; then
  # 设置时区为Asia/Hong_Kong
  timedatectl set-timezone "Asia/Hong_Kong"
  if [ $? -eq 0 ]; then
    echo -e "${Green}设置系统时区为 Asia/Hong_Kong 成功！${Plain}\n"
  else
    echo -e "${Red}设置系统时区失败，请重新设置！${Plain}\n"
  fi
else
  echo -e "当前时区已设置为 ${Green}Asia/Hong_Kong${Plain}，无需修改\n"
fi
