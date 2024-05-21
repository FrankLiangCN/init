#!/bin/bash

Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
UBlue='\033[4;34m'
Plain='\033[0m'

# 定义项
Option() {
  [[ x"$answer" == x"yes" || x"$answer" == x"YES" || x"$answer" == x"y" || x"$answer" == x"Y" || x"$answer" == x"" ]]
}

Default='(y/n) [默认yes]:'

Cancel_info() {
  echo -e "${Red}取消安装${Plain}\n"
}

Install_succ() {
  echo -e "${Green}安装成功${Plain}\n"
}

# apt 更新
read -p "是否进行apt更新？${Default}" answer
if Option; then
  echo -e "${Yellow}apt updating ...${Plain}"
  apt update >/dev/null 2>&1
  echo -e "${Green}apt 已更新${Plain}\n"
else
  echo -e "${Red}取消 apt 更新${Plain}\n"
fi
