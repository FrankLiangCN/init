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

# 安装 ddns-go
Install_ddns-go() {
  if Option; then
    echo -e "${Yellow}开始安装 ddns-go ...${Plain}"
    bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/DDNS/main/ddns.sh)
    if [ $? -eq 0 ]; then
      echo -e "${Green}ddns-go 安装/更新 成功${Plain}"
    else
      echo -e "${Red}ddns-go 安装失败，请参考文档或手动安装: ${UBlue}https://github.com/FrankLiangCN/DDNS${Plain}\n"
    fi
  else
    Cancel_info
  fi
}

ddns_login_info() {
  echo -e "${Green}请访问 ${UBlue}http://IP${ddns_port}${Green} 进行初始化配置${Plain}\n"
}

# 恢复 ddns-go 配置
Config_ddns() {
  if type ddns-go &>/dev/null; then
    read -p "是否恢复 ddns-go 配置？${Default}" answer
    if Option; then
      read -p "输入配置来源URL：" source_url
      if [ -z "${source_url}" ]; then
        source_url=https://sub.vsky.uk/ddns
      fi
      echo -e "配置来源URL为：${Yellow}${source_url}${Plain}\n"
      read -p "输入配置来源路径：" path
      if [ -z "${path}" ]; then
        path=default
      fi
      echo -e "配置来源路径为：${Yellow}${path}${Plain}\n"
      echo -e "${Yellow}开始恢复 ddns-go 配置...${Plain}\n"
      mv /opt/ddns-go/.ddns_go_config.yaml /opt/ddns-go/.ddns_go_config.yaml.bak
      curl -s -o /opt/ddns-go/.ddns_go_config.yaml ${source_url}/${path}/.ddns_go_config.yaml
      if [[ $? -ne 0 ]]; then
      	mv /opt/ddns-go/.ddns_go_config.yaml.bak /opt/ddns-go/.ddns_go_config.yaml
      else
      	rm -f /opt/ddns-go/.ddns_go_config.yaml.bak
      fi
      systemctl daemon-reload
      systemctl restart ddns-go
      echo -e "${Green}ddns-go 配置已恢复${Plain}\n"
    else
      echo -e "${Yellow}保留 ddns-go 当前配置${Plain}\n"
    fi
  fi
}

# 配置 ddns-go 端口
Config_ddns_port() {
  if type ddns-go &>/dev/null; then
    ddns_config_file="/etc/systemd/system/ddns-go.service"
    ddns_port=$(grep -i "ExecStart" $ddns_config_file|awk -F '"' '{print $4}')
    echo -e "当前 ddns-go 端口为${Yellow}${ddns_port}${Plain}"
    read -p "是否 更新 ddns-go 端口？${Default}" answer
    if Option; then
      read -p "请输入新 ddns-go 端口 [回车保留默认值]：" new_port
      if [ -z "${new_port}" ]; then
        new_port="${ddns_port}"
      else
        if [[ ! "${new_port}" =~ ^: ]]; then
          new_port=":${new_port}"
        fi
      fi
      echo -e "新 ddns-go 端口为${Yellow}${new_port}${Plain}\n"
      sed -i "s/${ddns_port}/${new_port}/g" $ddns_config_file
      systemctl daemon-reload
      systemctl restart ddns-go
      echo -e "${Green}ddns-go 端口已更新${Plain}\n"
      ddns_login_info
    else
      echo -e "${Red}取消 更新 ddns-go 端口${Plain}\n"
      ddns_login_info
    fi
  fi
}

if ! type ddns-go &>/dev/null; then
  read -p "是否安装 ddns-go？${Default}" answer
  Install_ddns-go
  Config_ddns
  Config_ddns_port
else
  echo -e "${Green}ddns-go 已安装${Plain}"
  read -p "是否更新 ddns-go？${Default}" answer
  Install_ddns-go
  Config_ddns
  Config_ddns_port
fi
