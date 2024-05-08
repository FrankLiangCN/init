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

# 安装 Rust 版 ServerStatus 云探针
Install_ServerStatus() {
  read -p "是否 安装/更新 客户端？${Default}" answer
  if Option; then
    read -p "请输入服务端域名/IP:端口：" url
    if [ -z "$url" ]; then
      url=https://vps.simpletechcn.com
    fi
    echo -e "新服务端域名/IP:端口为：${Yellow}$url${Plain}\n"
    read -p "请输入用户名：" username
    if [ -z "$username" ]; then
      username=uid
    fi
    echo -e "新用户名为：${Yellow}$username${Plain}\n"
    read -p "请输入密码：" password
    if [ -z "$password" ]; then
      password=pp
    fi
    echo -e "新密码为：${Yellow}$password${Plain}\n"
    read -p "是否启用 vnstat (0:不启用 / 默认1:启用)：" vnstat
    if [ -z "$vnstat" ]; then
      vnstat=1
    fi
    if [ "$vnstat" = "1" ]; then
      echo -e "${Green}vnstat已启用${Plain}\n"
    else
      echo -e "${Red}vnstat不启用${Plain}\n"
    fi
    curl -sSLf "${url}/i?pass=${password}&uid=${username}&vnstat=${vnstat}" | bash
    echo -e "${Green}ServerStatus 云探针客户端已安装/更新${Plain}\n"
  else
    echo -e "${Red}取消 安装/更新 ServerStatus 云探针客户端${Plain}\n"
  fi
}

if ! find /opt/ServerStatus/stat_client &>/dev/null; then
  echo -e "Rust 版 ServerStatus 云探针客户端${Red}未安装${Plain}"
  Install_ServerStatus
else
  echo -e "Rust 版 ServerStatus 云探针客户端${Green}已安装${Plain}"
  Install_ServerStatus
fi
