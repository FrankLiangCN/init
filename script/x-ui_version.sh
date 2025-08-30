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

x-ui_db() {
  if type x-ui &>/dev/null; then
    read -p "是否恢复 x-ui 配置？${Default}" answer
    if Option; then
      read -p "输入配置来源URL：" source_url
      if [ -z "${source_url}" ]; then
        source_url=https://sub.1980118.xyz/x-ui
      fi
      echo -e "配置来源URL为：${Yellow}${source_url}${Plain}\n"
      read -p "输入配置来源路径：" path
      if [ -z "${path}" ]; then
        path=default
      fi
      echo -e "配置来源路径为：${Yellow}${path}${Plain}\n"
      echo -e "${Yellow}开始恢复 x-ui 配置...${Plain}\n"
      mv /etc/x-ui/x-ui.db /etc/x-ui/x-ui.db.bak
      curl -s -o /etc/x-ui/x-ui.db ${source_url}/${path}/x-ui.db
      if [[ $? -ne 0 ]]; then
      	mv /etc/x-ui/x-ui.db.bak /etc/x-ui/x-ui.db
      else
      	rm -f /etc/x-ui/x-ui.db.bak
      fi
      x-ui restart
      echo -e "${Green}x-ui 配置已恢复${Plain}\n"
    else
      echo -e "${Yellow}保留 x-ui 当前配置${Plain}\n"
    fi
  fi
}

if ! type x-ui &>/dev/null; then
  read -p "是否安装 x-ui？${Default}" answer
  if Option; then
    read -p "输入 x-ui version (例如：v2.5.5)：" x-ui_version
    if [ -z "${x-ui_version}" ]; then
      x-ui_version=v2.5.5
    fi
    echo -e "${Yellow}开始安装 x-ui ${x-ui_version} ...${Plain}\n"
    VERSION=${x-ui_version} && bash <(curl -Ls "https://raw.githubusercontent.com/mhsanaei/3x-ui/$VERSION/install.sh") $VERSION
    x-ui_db
  else
    Cancel_info
  fi
else
  echo -e "${Green}x-ui 已安装${Plain}"
  x-ui_db
fi
