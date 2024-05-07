#!/bin/bash

Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
UBlue='\033[4;34m'
Plain='\033[0m'

# 常用端口号
common_port=(
  "22"
  "80"
  "443"
  "8080"
  "8443"
  "8000"
  "9000"
  "9443"
  "9876"
)

read -p "是否开放常用端口号(22,80,443,8080 ……)？(y/n) [默认yes]:" answer
if [[ x"$answer" == x"yes" || x"$answer" == x"YES" || x"$answer" == x"y" || x"$answer" == x"Y" || x"$answer" == x"" ]]; then
  for port in "${common_port[@]}"; do
    port_number=${port##*which }
    ufw allow ${port_number}
    echo -e "${Green}ufw 已开放端口号:${Yellow} ${port_number} ${Plain}\n"
  done
  echo -e "${Yellow}继续输入其它端口号${Plain}\n"
else
  echo -e "${Yellow}继续输入其它端口号${Plain}\n"  
fi

# 定义允许端口的函数
allow_port() {
  # 检查端口号是否为空
  if [ -z "$1" ]; then
    echo -e "${Yellow}请输入端口号${Plain}"
    return 1
  fi

  # 检查端口号是否为数字
  if [[ ! "$1" =~ ^[0-9]+$ ]]; then
    echo -e "${Yellow}端口号必须是数字${Plain}\n"
    return 1
  fi

  # 允许指定的TCP和UDP端口
  ufw allow $1  

  # 显示已允许的端口
  echo -e "${Green}ufw 已开放端口号:${Yellow} $1 ${Plain}\n"
}

# 循环允许端口
while true; do
  read -p "请输入要开放的端口号 (回车退出):" port

  # 检查用户是否按回车键退出
  if [ -z "$port" ]; then
    break
  fi

  allow_port $port
done

# 显示防火墙状态
ufw status
