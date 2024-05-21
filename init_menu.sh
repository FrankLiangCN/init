#!/bin/bash

# 设置颜色变量
Yellow='\033[0;33m'
Green='\033[0;32m'
Plain='\033[0m'
Red='\033[0;31m'

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
	
# 显示菜单
function show_menu() {
  echo -e ""
  echo -e "${Green}=========================================================${Plain}"
  echo -e "${Green}+                Linux 环境初始化部署脚本               +${Plain}"
  echo -e "${Green}=========================================================${Plain}"
  echo -e ""
  echo -e "请选择要执行的选项："
  echo -e " 1. 执行所有脚本"
  echo -e " 2. 设置系统时区"
  echo -e " 3. 开启 SSH Key 登录"
  echo -e " 4. 进行apt更新"
  echo -e " 5. 安装常用软件"
  echo -e " 6. 配置 NAT64"
  echo -e " 7. 安装 ddns-go"
  echo -e " 8. 安装/配置 x-ui"
  echo -e " 9. 安装 Caddy"
  echo -e "10. 安装 Docker & Container"
  echo -e "11. 安装 Fail2ban"
  echo -e "12. 安装/配置 ufw"
  echo -e "13. 安装 Rust 版 ServerStatus 云探针"
  echo -e "14. 安装 Rclone"
  echo -e "15. 安装 Tailscale"
  echo -e "16. 清理磁盘空间"
  echo -e "17. 修改 Root 密码"
  echo -e " 0. 退出"
}

# 获取用户选择
function get_choice() {
  echo -e ""
  read -p "输入选项: " choice
}

# 处理用户选择
function process_choice() {
  case $choice in
    1) # 执行所有脚本
      # 设置系统时区
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/timezone.sh)
      
      # 开启SSH Key登录选项
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/ssh_key.sh)
      
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
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/soft.sh)
      
      # 配置 NAT64
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/nat64.sh)
      
      # 安装 ddns-go
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/ddns.sh)
      
      # 安装/配置 x-ui
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/x-ui.sh)
      
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

      # 修改Root密码
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/change_passwd.sh)
      ;;
    2) # 设置系统时区
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/timezone.sh)
      ;;
    3) # 开启SSH Key登录选项
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/ssh_key.sh)
      ;;
    4) # apt 更新
      read -p "是否进行apt更新？${Default}" answer
      if Option; then
        echo -e "${Yellow}apt updating ...${Plain}"
        apt update >/dev/null 2>&1
        echo -e "${Green}apt 已更新${Plain}\n"
      else
        echo -e "${Red}取消 apt 更新${Plain}\n"
      fi
      ;;
    5) # 安装常用软件
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/soft.sh)
      ;;
    6) # 配置 NAT64
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/nat64.sh)
      ;;
    7) # 安装 ddns-go
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/ddns.sh)
      ;;
    8) # 安装/配置 x-ui
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/x-ui.sh)
      ;;
    9) # 安装 Caddy
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/caddy.sh)
      ;;
    10) # 安装 Docker & Container
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/docker_container.sh)
      ;;
    11) # 安装 Fail2ban
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/fail2ban.sh)
      ;;
    12) # 安装/配置 ufw
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/ufw.sh)
      ;;
    13) # 安装 Rust 版 ServerStatus 云探针
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/server_status.sh)
      ;;
    14) # 安装 Rclone
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/rclone.sh)
      ;;
    15) # 安装 Tailscale
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/tailscale.sh)
      ;;
    16) # 清理磁盘空间
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/clean.sh)
      ;;
    17) # 修改Root密码
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/change_passwd.sh)
      ;;
    0)
      echo -e "${Red}退出初始化部署脚本……${Plain}\n"
      exit 0
      ;;
    *)
      echo -e "${Yellow}无效选择，请重新输入选项序号${Plain}\n"
      ;;
  esac
}

# 主程序
while true; do
  show_menu
  get_choice
  process_choice
done
