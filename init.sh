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

echo -e ""
echo -e "${Green}=========================================================${Plain}"
echo -e "${Green}+              Linux 环境初始化自动部署脚本             +${Plain}"
echo -e "${Green}=========================================================${Plain}"
echo -e ""


# 设置系统时区
bash <(curl -sSL https://raw.githubusercontent.com/FrankLiangCN/init/main/timezone.sh)

# 开启SSH Key登录选项
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/ssh_key.sh)

# apt 更新
read -p "是否进行apt更新？${Default}" answer
if Option; then
  echo -e "${Yellow}apt updating ...${Plain}"
  apt update >/dev/null 2>&1
  echo -e "${Green}apt 已更新${Plain}\n"
else
  echo -e "${Red}取消 apt 更新${Plain}\n"
fi

# 安装常用软件
bash <(curl -sSL https://raw.githubusercontent.com/FrankLiangCN/init/main/soft.sh)

# 配置 NAT64
bash <(curl -sSL https://raw.githubusercontent.com/FrankLiangCN/init/main/nat64.sh)

# 安装 ddns-go
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/ddns.sh)

# 安装/配置x-ui
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/x-ui.sh)

# 安装Caddy
bash <(curl -sSL https://raw.githubusercontent.com/FrankLiangCN/init/main/caddy.sh)

# 安装 Docker & Container
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/docker_container.sh)

# 安装Fail2ban
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/fail2ban.sh)

# 安装/配置 ufw
bash <(curl -sSL https://raw.githubusercontent.com/FrankLiangCN/init/main/ufw.sh)

# 安装 Rust 版 ServerStatus 云探针
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/server_status.sh)

# 安装Rclone
bash <(curl -sSL https://raw.githubusercontent.com/FrankLiangCN/init/main/rclone.sh)

# 安装 Tailscale
bash <(curl -sSL https://raw.githubusercontent.com/FrankLiangCN/init/main/tailscale.sh)

# 清理磁盘空间
bash <(curl -sSL https://raw.githubusercontent.com/FrankLiangCN/init/main/clean.sh)

echo -e ""
echo -e "${Yellow}=========================================================${Plain}"
echo -e "${Yellow}             Linux 环境初始化自动部署成功！              ${Plain}"
echo -e "${Yellow}=========================================================${Plain}"
echo -e ""

# 修改Root密码
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/change_passwd.sh)
