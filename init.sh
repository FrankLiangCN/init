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
  echo -e "${Red}SSH服务已重启${Plain}\n"
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

# 配置NAT64
read -p "是否配置NAT64？${Default}" answer
if Option; then
  mv /etc/resolv.conf /etc/resolv.conf.bak
  echo -e "nameserver 2a01:4f8:c2c:123f::1\nnameserver 2001:67c:2b0::4\nnameserver 2001:67c:2b0::6\nnameserver 2606:4700:4700::64\nnameserver 2606:4700:4700::6400" > /etc/resolv.conf
  echo -e "${Green}NAT64已配置${Plain}\n"
else
  echo -e "${Red}取消NAT64配置${Plain}\n"
fi

# 安装ddns-go
Install_ddns-go () {
  if Option; then
    echo -e "${Yellow}开始安装 ddns-go ...${Plain}"
    bash <(curl -sSL https://raw.githubusercontent.com/FrankLiangCN/DDNS/main/ddns.sh)
    if [ $? -eq 0 ]; then
      echo -e "${Green}ddns-go 安装/更新 成功${Plain}"
    else
      echo -e "${Red}ddns-go 安装失败，请参考文档或手动安装: ${UBlue}https://github.com/FrankLiangCN/DDNS${Plain}\n"
    fi
  else
    Cancel_info
  fi
}

if ! type ddns-go &>/dev/null; then
  read -p "是否安装 ddns-go？${Default}" answer
  Install_ddns-go
  echo -e "${Green}请访问 ${UBlue}http://IP:9876${Green} 进行初始化配置${Plain}\n"
else
  echo -e "${Green}ddns-go 已安装${Plain}"
  read -p "是否更新 ddns-go？${Default}" answer
  Install_ddns-go
  echo -e "${Green}请访问 ${UBlue}http://IP:9876${Green} 配置 ddns-go${Plain}\n"
fi

# 安装/配置x-ui
x-ui_db() {
  if type x-ui &>/dev/null; then
    read -p "是否恢复x-ui配置？${Default}" answer
    if Option; then
      read -p "输入配置来源URL：" source_url
      if [ -z "$source_url" ]; then
        source_url=https://sub.vsky.uk/x-ui
      fi
      echo -e "配置来源URL为：${Yellow}$source_url${Plain}\n"
      read -p "输入配置来源路径：" path
      if [ -z "$path" ]; then
        path=default
      fi
      echo -e "配置来源路径为：${Yellow}$path${Plain}\n"
      echo -e "${Yellow}开始恢复 x-ui 配置 ...${Plain}\n"
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

# 安装Docker
if ! type docker &>/dev/null; then
  read -p "是否安装 Docker？${Default}" answer
  if Option; then
    echo -e "${Yellow}正在安装 Docker ...${Plain}"
    # Docker安装指令
    curl -fsSL https://get.docker.com | bash
    Install_succ
  else
    Cancel_info
  fi
else
  echo -e "${Green}Docker 已安装${Plain}\n"
fi

# 安装Docker容器Portainer
Install_portainer () {
  if ! docker ps | grep portainer &>/dev/null; then
    read -p "是否安装 Portainer？${Default}" answer
    if Option; then
      echo -e "${Yellow}开始安装 Portainer ...${Plain}\n"
      docker volume create portainer_data
      docker run -d --network host --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
      echo -e "${Green}Portainer 安装成功，${Red}5分钟内${Green}访问 ${UBlue}http://IP:9000${Green} 进行初始化配置${Plain}\n"
    else
      Cancel_info
    fi
  else
    echo -e "${Green}Portainer 已安装${Plain}\n"
  fi
}

if ! type docker &>/dev/null; then
  echo -e "安装 Portainer 容器前，${Yellow}需先安装 Docker!${Plain}"
  read -p "是否安装 Docker？${Default}" answer
  if Option; then
    echo -e "${Yellow}正在安装 Docker ...${Plain}\n"
    curl -fsSL https://get.docker.com | bash
    echo ""
    if type docker &>/dev/null; then
      echo -e "${Yellow}进入 Portainer 安装脚本...${Plain}\n"
      Install_portainer
    else
      echo -e "${Red}Docker 安装失败，退出 Portainer 容器安装!${Plain}\n"
    fi
  else
    echo -e "${Red}Docker 取消安装，退出 Portainer 容器安装!${Plain}\n"
  fi
else
  Install_portainer
fi

# 安装Docker容器Watchtower
Install_watchtower() {
  if ! docker ps | grep watchtower &>/dev/null; then
    read -p "是否安装 Watchtower？${Default}" answer
    if Option; then
      echo -e "${Yellow}开始安装 Watchtower ...${Plain}\n"
      docker run -d --name watchtower --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
      Install_succ
    else
      Cancel_info
    fi
  else
    echo -e "${Green}Watchtower 已安装${Plain}\n"
  fi
}

if ! type docker &>/dev/null; then
  echo -e "安装 Watchtower 容器前，${Yellow}需先安装 Docker!${Plain}"
  read -p "是否安装 Docker？${Default}" answer
  if Option; then
    echo -e "${Yellow}开始安装 Docker ...${Plain}\n"
    curl -fsSL https://get.docker.com | bash
    echo ""
    if type docker &>/dev/null; then
      echo -e "进入 Watchtower 安装脚本...\n"
      Install_watchtower
    else
      echo -e "${Red}Docker 安装失败，退出 Watchtower 容器安装!${Plain}\n"
    fi
  else
    echo -e "${Red}Docker 取消安装，退出 Watchtower 容器安装!${Plain}\n"
  fi
else
  Install_watchtower
fi

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
      read -p "请输入新的 bantime 值（回车保留默认值）：" new_bantime
      if [ -z "$new_bantime" ]; then
        new_bantime=$current_bantime
      fi
      echo -e "新的 bantime 值为：${Yellow}$new_bantime${Plain}\n"
      sed -i "s/^bantime\s*=\s*$current_bantime/bantime = $new_bantime/1" $jail_file
  	  echo "当前 findtime 值为：$current_findtime"
      read -p "请输入新的 findtime 值（回车保留默认值）：" new_findtime
      if [ -z "$new_findtime" ]; then
        new_findtime=$current_findtime
      fi
      echo -e "新的 findtime 值为：${Yellow}$new_findtime${Plain}\n"
      sed -i "s/^findtime\s*=\s*$current_findtime/findtime = $new_findtime/1" $jail_file
  	  echo "当前 maxretry 值为：$current_maxretry"
      read -p "请输入新的 maxretry 值（回车保留默认值）：" new_maxretry
      if [ -z "$new_maxretry" ]; then
        new_maxretry=$current_maxretry
      fi
      echo -e "新的 maxretry 值为：${Yellow}$new_maxretry${Plain}\n"
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
    Install_succ
    Config_fail2ban
  else
    Cancel_info
  fi
else
  echo -e "${Green}Fail2ban 已安装${Plain}"
  Config_fail2ban
fi

# 安装 Rust 版 ServerStatus 云探针
Install_ServerStatus() {
  read -p "是否 安装/更新 客户端？${Default}" answer
  if Option; then
    read -p "请输入服务端域名/IP:端口：" url
    if [ -z "$url" ]; then
      url=https://vps.simpletechcn.com
    fi
    echo -e "新的服务端域名/IP:端口为：${Yellow}$url${Plain}\n"
    read -p "请输入用户名：" username
    if [ -z "$username" ]; then
      username=uid
    fi
    echo -e "新的用户名为：${Yellow}$username${Plain}\n"
    read -p "请输入密码：" password
    if [ -z "$password" ]; then
      password=pp
    fi
    echo -e "新的密码为：${Yellow}$password${Plain}\n"
    read -p "是否启用 vnstat (0:不启用 / 默认1:启用)：" vnstat
    if [ -z "$vnstat" ]; then
      vnstat=1
    fi
    if [ "$vnstat" = "1" ]; then
      echo -e "${Green}vnstat已启用${Plain}\n"
    else
      echo -e "${Red}vnstat不启用${Plain}\n"
    fi
    curl -sSLf "${url}/i?pass=${password}&uid=${username}&vnstat=${vnstat}" | bash
    echo -e "${Green}ServerStatus 云探针客户端已安装/更新${Plain}\n"
  else
    echo -e "${Red}取消 安装/更新 ServerStatus 云探针客户端${Plain}\n"
  fi
}

if ! find /opt/ServerStatus/stat_client &>/dev/null; then
  echo -e "Rust 版 ServerStatus 云探针客户端${Red}未安装${Plain}"
  Install_ServerStatus
else
  echo -e "Rust 版 ServerStatus 云探针客户端${Green}已安装${Plain}"
  Install_ServerStatus
fi

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
    echo "0 0 */7 * *  bash /opt/cleandata.sh > /dev/null 2>&1" >> /var/spool/cron/crontabs/root
    #echo "0 0 */7 * *  root bash /opt/cleandata.sh > /dev/null 2>&1" >> /etc/crontab
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
echo -e "修改 Root 密码后，${Red}须断开所有连接，使用新密码重新登录！！${Plain}"
read -p "是否修改 Root 密码？${Default}" answer
if Option; then
  read -p "请输入新密码：" new_password
  if [ -z "$new_password" ]; then
    new_password=@Sz123456
  fi
  echo -e "新的 Root 密码为：${Yellow}$new_password${Plain}"
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
