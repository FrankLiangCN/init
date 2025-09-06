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
echo -e "${Green}+                Linux 环境初始化部署脚本               +${Plain}"
echo -e "${Green}=========================================================${Plain}"
echo -e ""


# 设置系统时区
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/timezone.sh)

# 开启 SSH Key 登录选项
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/ssh_key.sh)

# apt 更新
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/apt_update.sh)

# 安装常用软件
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/soft.sh)

# 配置 NAT64
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/nat64.sh)

# 安装 ddns-go
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/ddns.sh)

# 安装/配置x-ui
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/x-ui.sh)

# 安装/配置 Hysteria
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/hystera.sh)

# 安装 Caddy
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/caddy.sh)

# 安装 Docker & Container
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/docker_container.sh)

# 安装 Fail2ban
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/fail2ban.sh)

# 安装/配置 ufw
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/ufw.sh)

# 安装 Rust 版 ServerStatus 云探针
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/server_status.sh)

# 安装 Rclone
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/rclone.sh)

# 安装 Tailscale
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/tailscale.sh)

# 清理磁盘空间
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/clean.sh)

echo -e ""
echo -e "${Yellow}=========================================================${Plain}"
echo -e "${Yellow}               Linux 环境初始化部署成功！                ${Plain}"
echo -e "${Yellow}=========================================================${Plain}"
echo -e ""

# 修改Root密码
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/change_passwd.sh)
