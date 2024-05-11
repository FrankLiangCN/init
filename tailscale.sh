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


# 安装 Tailscale
if ! type tailscale &>/dev/null; then
  read -p "是否安装 Tailscale？${Default}" answer
  if Option; then
    echo -e "${Yellow}开始安装 Tailscale ...${Plain}"
    curl -fsSL https://tailscale.com/install.sh | sh
    if type tailscale &>/dev/null; then
      Install_succ
    else
      echo -e "${Red}Tailscale 安装失败，需重新安装${Plain}\n"
    fi
  else
    Cancel_info
  fi
else
  echo -e "${Green}Tailscale 已安装${Plain}\n"
fi
