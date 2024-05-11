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

# 安装Rclone
Config_rclone() {
  if type rclone &>/dev/null; then
    read -p "是否配置 Rclone？${Default}" answer
    if Option; then
      rclone config
    else
      echo -e "${Red}取消配置${Plain}，后续输入${Yellow} rclone config ${Plain}进行配置\n"
    fi
  else
    echo ""
  fi
}

if ! type rclone &>/dev/null; then
  read -p "是否安装 Rclone？${Default}" answer
  if Option; then
    echo -e "${Yellow}开始安装 Rclone ...${Plain}"
    curl https://rclone.org/install.sh | bash
    Install_succ
    Config_rclone
  else
    Cancel_info
  fi
else
  echo -e "${Green}Rclone 已安装${Plain}"
  Config_rclone
fi
