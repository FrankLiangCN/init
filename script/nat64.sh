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

# 配置 NAT64
read -p "是否配置NAT64？${Default}" answer
if Option; then
  echo -e "${Yellow}备份 resolv.conf 文件...${Plain}"
  mv /etc/resolv.conf /etc/resolv.conf.bak
  echo -e "nameserver 2a01:4f8:c2c:123f::1\nnameserver 2001:67c:2b0::4\nnameserver 2001:67c:2b0::6\nnameserver 2606:4700:4700::64\nnameserver 2606:4700:4700::6400\nnameserver 2001:4860:4860::64\nnameserver 2001:4860:4860::6464" > /etc/resolv.conf
  echo -e "${Green}NAT64 已配置${Plain}\n"
else
  echo -e "${Red}取消 NAT64 配置${Plain}\n"
fi
