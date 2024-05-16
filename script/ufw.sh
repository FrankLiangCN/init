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

# 安装/配置 ufw
if ! type ufw &>/dev/null; then
  read -p "是否安装 ufw？${Default}" answer
  if Option; then
    echo -e "${Yellow}开始安装 ufw ...${Plain}"
    apt-get -y install ufw
    if type ufw &>/dev/null; then
      Install_succ
      read -p "是否配置开放端口号？${Default}" answer
      if Option; then
        bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/ufw_allow_port.sh)
      else
        Cancel_info
      fi
      ufw enable
      ufw status
    else
      echo -e "${Red}ufw 安装失败，需重新安装${Plain}\n"
    fi
  else
    Cancel_info
  fi
else
  echo -e "${Green}ufw 已安装${Plain}"
  read -p "是否配置开放端口号？${Default}" answer
    if Option; then
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/ufw_allow_port.sh)
    else
      Cancel_info
    fi
fi
