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

# 安装Fail2ban
# 修改Fail2ban默认配置
Config_fail2ban() {
  if type fail2ban-client &>/dev/null; then
    read -p "是否修改 Fail2ban 默认配置？${Default}" answer
    if Option; then
      echo -e "${Yellow}开始配置 Fail2ban ...${Plain}\n"
      if [ -f /etc/fail2ban/jail.local ]; then
        echo -e "${Yellow}jail.local 文件已存在${Plain}\n"
      else
        # 复制默认的 jail.conf 文件
        cp /etc/fail2ban/jail.{conf,local}
        echo -e "${Yellow}jail.local 文件已复制${Plain}\n"
      fi
      # 设置要修改的文件
      jail_file="/etc/fail2ban/jail.local"
      # 检测bantime参数
      current_bantime=$(grep -E "^\s*bantime\s+" $jail_file | awk '{print $3}' | head -n 1)
      # 检测findtime参数
      current_findtime=$(grep -E "^\s*findtime\s+" $jail_file | awk '{print $3}' | head -n 1)
      # 检测maxretry参数
      current_maxretry=$(grep -E "^\s*maxretry\s+" $jail_file | awk '{print $3}' | head -n 1)
      # 设置要修改的值
      echo "当前 bantime 值为：$current_bantime"
      read -p "请输入新 bantime 值 [回车保留默认值]：" new_bantime
      if [ -z "$new_bantime" ]; then
        new_bantime=$current_bantime
      fi
      echo -e "新 bantime 值为：${Yellow}$new_bantime${Plain}\n"
      sed -i "s/^bantime\s*=\s*$current_bantime/bantime = $new_bantime/1" $jail_file
  	  echo "当前 findtime 值为：$current_findtime"
      read -p "请输入新 findtime 值 [回车保留默认值]：" new_findtime
      if [ -z "$new_findtime" ]; then
        new_findtime=$current_findtime
      fi
      echo -e "新 findtime 值为：${Yellow}$new_findtime${Plain}\n"
      sed -i "s/^findtime\s*=\s*$current_findtime/findtime = $new_findtime/1" $jail_file
  	  echo "当前 maxretry 值为：$current_maxretry"
      read -p "请输入新 maxretry 值 [回车保留默认值]：" new_maxretry
      if [ -z "$new_maxretry" ]; then
        new_maxretry=$current_maxretry
      fi
      echo -e "新 maxretry 值为：${Yellow}$new_maxretry${Plain}\n"
      sed -i "s/^maxretry\s*=\s*$current_maxretry/maxretry = $new_maxretry/1" $jail_file
      # 启用SSHD Jail
      #sed -i '/^\[sshd\]/{n;/^\s*enabled\s*=/ {s/false/true/;t};s/$/\nenabled = true/}' $jail_file
      sed -i '/enabled = true/d' $jail_file
      sed -i '/^\[sshd\]/{n;/enabled *= *true/!s/.*/&\nenabled = true/}' $jail_file
      # 重启 fail2ban 服务
      systemctl restart fail2ban
      echo -e "${Red}Fail2ban 配置已更新并重启${Plain}\n"
      sleep 3
      fail2ban-client status
      echo ""
    else
      echo -e "${Yellow}保留默认配置${Plain}\n"
      fail2ban-client status
      echo ""
    fi
  else
    echo ""
  fi
}

if ! type fail2ban-client &>/dev/null; then
  read -p "是否安装 Fail2ban？${Default}" answer
  if Option; then
    echo -e "${Yellow}开始安装 Fail2ban ...${Plain}"
    apt-get -y install fail2ban
    if type fail2ban-client &>/dev/null; then
      Install_succ
      Config_fail2ban
    else
      echo -e "${Red}Fail2ban 安装失败，需重新安装${Plain}\n"
    fi
  else
    Cancel_info
  fi
else
  echo -e "${Green}Fail2ban 已安装${Plain}"
  Config_fail2ban
fi
