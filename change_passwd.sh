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

# 修改Root密码
echo -e "修改 Root 密码后，${Red}须断开所有连接，使用新密码重新登录！！${Plain}"
read -p "是否修改 Root 密码？${Default}" answer
if Option; then
  read -p "请输入新密码：" new_password
  if [ -z "$new_password" ]; then
    new_password=@Sz123456
  fi
  echo -e "新 Root 密码为：${Yellow}$new_password${Plain}"
  # 更改 root 密码
  echo "root:$new_password" | chpasswd
  sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
  service ssh restart
  # 检查是否成功更改密码
  if [ $? -eq 0 ]; then
    echo -e "Root 密码已成功更改为：${Yellow}$new_password${Plain}\n"
    read -p "是否立即断开所有连接？${Default}" answer
    if Option; then
      echo -e "${Red}自动断开所有连接，使用新 Root 密码重新登录${Plain}"
      current_tty=$(tty)
      pts_list=$(who | awk '{print $2}')
      for pts in $pts_list; do
        [ "$current_tty" != "/dev/$pts" ]
        pkill -9 -t $pts
      done
    else
      echo -e "${Red}需手动断开所有连接，使用新 Root 密码重新登录${Plain}\n" 
    fi
  else
    echo -e "${Red}更改 Root 密码失败${Plain}\n"
  fi
else
  echo -e "${Yellow}Root 密码未变更${Plain}\n"
fi
