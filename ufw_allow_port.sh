#!/bin/bash

Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
UBlue='\033[4;34m'
Plain='\033[0m'

# 定义允许端口的函数
allow_port() {
  # 检查端口号是否为空
  if [ -z "$1" ]; then
    echo -e "${Yellow}请输入端口号${Plain}"
    return 1
  fi

  # 检查端口号是否为数字
  if [[ ! "$1" =~ ^[0-9]+$ ]]; then
    echo -e "${Yellow}端口号必须是数字${Plain}"
    return 1
  fi

  # 允许指定的TCP和UDP端口
  ufw allow $1  

  # 显示已允许的端口
  echo -e "${Green}ufw 已开放端口:${Yellow} $1 ${Plain}\n"
}

# 循环允许端口
while true; do
  read -p "请输入要开放的端口号 (空行退出):" port

  # 检查用户是否按回车键退出
  if [ -z "$port" ]; then
    break
  fi

  allow_port $port
done

# 显示防火墙状态
ufw status
