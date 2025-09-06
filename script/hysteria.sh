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

# 生成自签证书
Own_cert() {
  openssl req -x509 -nodes -newkey ec:<(openssl ecparam -name prime256v1) -keyout /etc/hysteria/server.key -out /etc/hysteria/server.crt -subj "/CN=bing.com" -days 36500 && chown hysteria /etc/hysteria/server.key && sudo chown hysteria /etc/hysteria/server.crt
}

hysteria_config() {
  if type hysteria &>/dev/null; then
    read -p "是否恢复 Hysteria 配置？${Default}" answer
    if Option; then
      read -p "输入配置来源URL：" source_url
      if [ -z "${source_url}" ]; then
        source_url=https://sub.1980118.xyz
      fi
      echo -e "配置来源URL为：${Yellow}${source_url}${Plain}\n"
      read -p "输入配置来源路径：" path
      if [ -z "${path}" ]; then
        path=hysteria
      fi
      echo -e "配置来源路径为：${Yellow}${path}${Plain}\n"
      echo -e "${Yellow}开始恢复 Hysteria 配置...${Plain}\n"
      mv /etc/hysteria/config.yaml /etc/hysteria/config.yaml.bak
      curl -s -o /etc/hysteria/config.yaml ${source_url}/${path}/config.yaml
      if [[ $? -ne 0 ]]; then
      	mv /etc/hysteria/config.yaml.bak /etc/hysteria/config.yaml
      else
      	rm -f /etc/hysteria/config.yaml.bak
      fi
      systemctl restart hysteria-server.service
      echo -e "${Green}Hysteria 配置已恢复${Plain}\n"
    else
      echo -e "${Yellow}保留 Hysteria 当前配置${Plain}\n"
    fi
  fi
}

if ! type hysteria &>/dev/null; then
  read -p "是否安装 Hysteria？${Default}" answer
  if Option; then
    echo -e "${Yellow}开始安装 Hysteria ...${Plain}\n"
    bash <(curl -fsSL https://get.hy2.sh/)
    Own_cert
    systemctl enable hysteria-server.service
    systemctl start hysteria-server.service
    hysteria_config
  else
    Cancel_info
  fi
else
  echo -e "${Green}Hysteria 已安装${Plain}"
  hysteria_config
fi
