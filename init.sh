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
# 获取当前时区
current_timezone=$(date +%Z)

# 判断当前时区是否为Asia/Hong_Kong
if [ "$current_timezone" != "HKT" ]; then
  # 设置时区为Asia/Hong_Kong
  timedatectl set-timezone "Asia/Hong_Kong"
  if [ $? -eq 0 ]; then
    echo -e "${Green}设置系统时区为 Asia/Hong_Kong 成功！${Plain}\n"
  else
    echo -e "${Red}设置系统时区失败，请重新设置！${Plain}\n"
  fi
else
  echo -e "当前时区已设置为 ${Green}Asia/Hong_Kong${Plain}，无需修改\n"
fi

# 开启SSH Key登录选项
# 定义SSH配置文件路径
ssh_config_file="/etc/ssh/sshd_config"

# 检测PubkeyAuthentication参数
pubkey_authentication=$(grep -E "^\s*PubkeyAuthentication\s+" $ssh_config_file | awk '{print $2}')

# 检测RSAAuthentication参数
rsa_authentication=$(grep -E "^\s*RSAAuthentication\s+" $ssh_config_file | awk '{print $2}')

ssh_key_enable() {
  echo -e "SSH Key 登录选项${Green}已开启${Plain}"
  service ssh restart
  echo -e "${Red}SSH 服务已重启${Plain}\n"
}

# 判断SSH参数并修改配置
if [ "$pubkey_authentication" = "no" ] && [ "$rsa_authentication" = "no" ]; then
  echo -e "${Yellow}修改${Plain} PubkeyAuthentication 和 RSAAuthentication 参数为 ${Green}yes${Plain}..."
  sed -i 's/^\s*PubkeyAuthentication\s*no/PubkeyAuthentication yes/g' $ssh_config_file
  sed -i 's/^\s*RSAAuthentication\s*no/RSAAuthentication yes/g' $ssh_config_file
  ssh_key_enable
elif [ "$pubkey_authentication" = "yes" ] && [ "$rsa_authentication" = "no" ]; then
  echo -e "${Yellow}修改${Plain} RSAAuthentication 参数为 ${Green}yes${Plain}..."
  sed -i 's/^\s*RSAAuthentication\s*no/RSAAuthentication yes/g' $ssh_config_file
  ssh_key_enable
elif [ "$pubkey_authentication" = "yes" ] && [ -z "$rsa_authentication" ]; then
  echo -e "${Yellow}增加${Plain} RSAAuthentication ${Green}yes${Plain}..."
  echo "RSAAuthentication yes" >> $ssh_config_file
  ssh_key_enable
elif [ "$pubkey_authentication" = "no" ] && [ -z "$rsa_authentication" ]; then
  echo -e "${Yellow}修改${Plain} PubkeyAuthentication 参数为 ${Green}yes${Plain} 和 ${Yellow}增加${Plain} RSAAuthentication ${Green}yes${Plain}..."
  sed -i 's/^\s*PubkeyAuthentication\s*no/PubkeyAuthentication yes/g' $ssh_config_file
  echo "RSAAuthentication yes" >> $ssh_config_file
  ssh_key_enable
elif [ -z "$pubkey_authentication" ] && [ -z "$rsa_authentication" ]; then
  echo -e "${Yellow}增加${Plain} PubkeyAuthentication ${Green}yes${Plain} 和 RSAAuthentication ${Green}yes${Plain}..."
  echo "PubkeyAuthentication yes" >> $ssh_config_file
  echo "RSAAuthentication yes" >> $ssh_config_file
  ssh_key_enable
else
  echo -e "SSH Key 登录选项${Green}已开启${Plain}，无需修改配置...\n"
fi

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
cmdline=(
    "curl"
    "wget"
    "tar"
    "unzip"
    "vim"
    "nano"
    "htop"
    "vnstat"
    "dos2unix"
    "zsh"
)

for soft in "${cmdline[@]}"; do
    if command -v "$soft" >/dev/null; then
      echo -e "${Green}$soft 已安装${Plain}\n"
    else
      name=${soft##*which }
      echo -e "${Yellow}${name} 安装中 ...${Plain}"
      apt install -y ${name} >/dev/null 2>&1
      if [[ $? -eq 0 ]]; then
        echo -e "${Green}${name} 安装成功${Plain}\n"
      else
        echo -e "${Red}${name} 安装失败${Plain}\n"
      fi
    fi
done

# 配置 NAT64
read -p "是否配置NAT64？${Default}" answer
if Option; then
  echo -e "${Yellow}备份 resolv.conf 文件...${Plain}"
  mv /etc/resolv.conf /etc/resolv.conf.bak
  echo -e "nameserver 2a01:4f8:c2c:123f::1\nnameserver 2001:67c:2b0::4\nnameserver 2001:67c:2b0::6\nnameserver 2606:4700:4700::64\nnameserver 2606:4700:4700::6400" > /etc/resolv.conf
  echo -e "${Green}NAT64 已配置${Plain}\n"
else
  echo -e "${Red}取消 NAT64 配置${Plain}\n"
fi

# 安装 ddns-go
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/ddns.sh)

# 安装/配置x-ui
x-ui_db() {
  if type x-ui &>/dev/null; then
    read -p "是否恢复 x-ui 配置？${Default}" answer
    if Option; then
      read -p "输入配置来源URL：" source_url
      if [ -z "${source_url}" ]; then
        source_url=https://sub.vsky.uk/x-ui
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
    echo -e "${Yellow}开始安装 x-ui ...${Plain}\n"
    bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
    x-ui_db
  else
    Cancel_info
  fi
else
  echo -e "${Green}x-ui 已安装${Plain}"
  x-ui_db
fi

# 安装Caddy
if ! type caddy &>/dev/null; then
  read -p "是否安装 Caddy？${Default}" answer
  if Option; then
    echo -e "${Yellow}正在安装 Caddy ...${Plain}"
    # Caddy安装指令
    apt install -y debian-keyring debian-archive-keyring apt-transport-https
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
    apt update && apt install caddy
    echo -e "${Green}Caddy 安装成功${Plain}\n"
  else
    Cancel_info
  fi
else
  echo -e "${Green}Caddy 已安装${Plain}\n"
fi

# 安装 Docker & Container
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/docker_container.sh)

# 安装Fail2ban
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/fail2ban.sh)

# 安装/配置 ufw
if ! type ufw &>/dev/null; then
  read -p "是否安装 ufw？${Default}" answer
  if Option; then
    echo -e "${Yellow}开始安装 ufw ...${Plain}"
    apt-get -y install ufw
    if type ufw &>/dev/null; then
      Install_succ
      read -p "是否配置开放端口号？${Default}" answer
      if Option; then
        bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/ufw_allow_port.sh)
      else
        Cancel_info
      fi
      ufw enable
      ufw status
    else
      echo -e "${Red}ufw 安装失败，需重新安装${Plain}\n"
    fi
  else
    Cancel_info
  fi
else
  echo -e "${Green}ufw 已安装${Plain}"
  read -p "是否配置开放端口号？${Default}" answer
    if Option; then
      bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/ufw_allow_port.sh)
    else
      Cancel_info
    fi
fi

# 安装 Rust 版 ServerStatus 云探针
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/server_status.sh)

# 安装Rclone
Config_rclone() {
  if type rclone &>/dev/null; then
    read -p "是否配置 Rclone？${Default}" answer
    if Option; then
      rclone config
    else
      echo -e "${Red}取消配置${Plain}，后续输入${Yellow} rclone config ${Plain}进行配置\n"
    fi
  else
    echo ""
  fi
}

if ! type rclone &>/dev/null; then
  read -p "是否安装 Rclone？${Default}" answer
  if Option; then
    echo -e "${Yellow}开始安装 Rclone ...${Plain}"
    curl https://rclone.org/install.sh | bash
    Install_succ
    Config_rclone
  else
    Cancel_info
  fi
else
  echo -e "${Green}Rclone 已安装${Plain}"
  Config_rclone
fi

# 安装 Tailscale
if ! type tailscale &>/dev/null; then
  read -p "是否安装 Tailscale？${Default}" answer
  if Option; then
    echo -e "${Yellow}开始安装 Tailscale ...${Plain}"
    curl -fsSL https://tailscale.com/install.sh | sh
    if type tailscale &>/dev/null; then
      Install_succ
    else
      echo -e "${Red}Tailscale 安装失败，需重新安装${Plain}\n"
    fi
  else
    Cancel_info
  fi
else
  echo -e "${Green}Tailscale 已安装${Plain}\n"
fi

# 检测定时清理磁盘空间任务是否已设置
if ! type /opt/cleandata.sh &>/dev/null; then
  read -p "是否设置定时清理磁盘空间任务？${Default}" answer
  if Option; then
    echo -e "${Yellow}正在设置定时清理磁盘空间任务...${Plain}"
    wget --no-check-certificate -O /opt/cleandata.sh https://raw.githubusercontent.com/FrankLiangCN/init/main/cleandata.sh
    chmod +x /opt/cleandata.sh
    echo -e "${Yellow}正在清理磁盘空间${Plain}\n"
    bash /opt/cleandata.sh
    echo -e "${Yellow}磁盘空间已清理${Plain}\n"
    echo "0 0 */7 * * bash /opt/cleandata.sh > /dev/null 2>&1" >> /var/spool/cron/crontabs/root
    #echo "0 0 */7 * * root bash /opt/cleandata.sh > /dev/null 2>&1" >> /etc/crontab
    echo -e "${Green}定时清理磁盘空间任务已设置${Plain}\n"
  else
    echo -e "${Red}取消设置${Plain}\n"
  fi
else
  echo -e "${Green}定时清理磁盘空间任务已设置${Plain}\n"
fi

echo -e ""
echo -e "${Yellow}=========================================================${Plain}"
echo -e "${Yellow}             Linux 环境初始化自动部署成功！              ${Plain}"
echo -e "${Yellow}=========================================================${Plain}"
echo -e ""

# 修改Root密码
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/change_passwd.sh)
