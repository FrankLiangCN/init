#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

# 定义项
Option() {
  [[ x"$answer" == x"yes" || x"$answer" == x"YES" || x"$answer" == x"y" || x"$answer" == x"Y" || x"$answer" == x"" ]]
}

Default='(y/n) [默认yes]:'

Cancel_info() {
  echo -e "${red}取消安装${plain}\n"
}

Install_succ() {
  echo -e "${green}安装成功${plain}\n"
}

echo -e ""
echo -e "${green}=========================================================${plain}"
echo -e "${green}+              Linux 环境初始化自动部署脚本             +${plain}"
echo -e "${green}=========================================================${plain}"
echo -e ""


# 开启SSH Key登录选项
# 定义SSH配置文件路径
ssh_config_file="/etc/ssh/sshd_config"

# 检测PubkeyAuthentication参数
pubkey_authentication=$(grep -E "^\s*PubkeyAuthentication\s+" $ssh_config_file | awk '{print $2}')

# 检测RSAAuthentication参数
rsa_authentication=$(grep -E "^\s*RSAAuthentication\s+" $ssh_config_file | awk '{print $2}')

ssh_key_enable() {
  echo -e "SSH Key 登录选项${green}已开启${plain}"
  service ssh restart
  echo -e "${red}SSH服务已重启${plain}\n"
}

# 判断SSH参数并修改配置
if [ "$pubkey_authentication" = "no" ] && [ "$rsa_authentication" = "no" ]; then
  echo -e "修改 PubkeyAuthentication 和 RSAAuthentication 参数为${green} yes${plain}..."
  sed -i 's/^\s*PubkeyAuthentication\s*no/PubkeyAuthentication yes/g' $ssh_config_file
  sed -i 's/^\s*RSAAuthentication\s*no/RSAAuthentication yes/g' $ssh_config_file
  ssh_key_enable
elif [ "$pubkey_authentication" = "yes" ] && [ "$rsa_authentication" = "no" ]; then
  echo -e "修改 RSAAuthentication 参数为${green} yes${plain}..."
  sed -i 's/^\s*RSAAuthentication\s*no/RSAAuthentication yes/g' $ssh_config_file
  ssh_key_enable
elif [ "$pubkey_authentication" = "yes" ] && [ -z "$rsa_authentication" ]; then
  echo -e "增加 RSAAuthentication${green} yes${plain}..."
  echo "RSAAuthentication yes" >> $ssh_config_file
  ssh_key_enable
elif [ "$pubkey_authentication" = "no" ] && [ -z "$rsa_authentication" ]; then
  echo -e "修改 PubkeyAuthentication 参数为${green} yes ${plain}和 增加 RSAAuthentication${green} yes${plain}..."
  sed -i 's/^\s*PubkeyAuthentication\s*no/PubkeyAuthentication yes/g' $ssh_config_file
  echo "RSAAuthentication yes" >> $ssh_config_file
  ssh_key_enable
elif [ -z "$pubkey_authentication" ] && [ -z "$rsa_authentication" ]; then
  echo -e "增加 PubkeyAuthentication${green} yes ${plain}和 RSAAuthentication${green} yes${plain}..."
  echo "PubkeyAuthentication yes" >> $ssh_config_file
  echo "RSAAuthentication yes" >> $ssh_config_file
  ssh_key_enable
else
  echo -e "SSH Key 登录选项${green}已开启${plain}，无需修改配置...\n"
fi

# 设置系统时区
# 获取当前时区
current_timezone=$(date +%Z)

# 判断当前时区是否为Asia/Hong_Kong
if [ "$current_timezone" != "HKT" ]; then
  # 设置时区为Asia/Hong_Kong
  timedatectl set-timezone "Asia/Hong_Kong"
  if [ $? -eq 0 ]; then
    echo -e "${green}设置系统时区为 Asia/Hong_Kong 成功！${plain}\n"
  else
    echo -e "${red}设置系统时区失败，请重新设置！${plain}\n"
  fi
else
  echo -e "当前时区已设置为${green} Asia/Hong_Kong${plain}，无需修改\n"
fi

# apt 更新
read -p "是否进行apt更新？${Default}" answer
if Option; then
  echo "apt updating ..."
  apt update >/dev/null 2>&1
  echo -e "${green}apt 已更新${plain}\n"
else
  echo -e "${red}取消 apt 更新${plain}\n"
fi

# 安装常用软件
cmdline=(
    "curl"
    "wget"
    "tar"
    "unzip"
    "vim"
    "nano"
    "vnstat"
)

for soft in "${cmdline[@]}"; do
    if command -v "$soft" >/dev/null; then
      echo -e "${green}$soft 已安装${plain}\n"
    else
      name=${soft##*which }
      echo -e "${name} 安装中 ..."
      apt install -y ${name} >/dev/null 2>&1
      if [[ $? -eq 0 ]]; then
        echo -e "${green}${name} 安装成功${plain}\n"
      else
        echo -e "${red}${name} 安装失败${plain}\n"
      fi
    fi
done

# 安装ddns-go
if ! type ddns-go &>/dev/null; then
  read -p "是否安装 ddns-go？${Default}" answer
  if Option; then
    echo "开始安装 ddns-go ..."
    bash <(curl -sSL https://raw.githubusercontent.com/FrankLiangCN/DDNS/main/ddns.sh)
    echo -e "${green}ddns-go 安装成功，请访问 http://IP:9876 进行初始化配置${plain}\n"
  else
    Cancel_info
  fi
else
  echo -e "${green}ddns-go 已安装，请访问 http://IP:9876 进行配置${plain}\n"
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
      echo -e "配置来源URL为：$source_url\n"
      read -p "输入配置来源路径：" path
      if [ -z "$path" ]; then
        path=default
      fi
      echo -e "配置来源路径为：$path\n"
      echo -e "开始恢复 x-ui 配置 ...\n"
      mv /etc/x-ui/x-ui.db /etc/x-ui/x-ui.db.bak
      curl -s -o /etc/x-ui/x-ui.db ${source_url}/${path}/x-ui.db
      if [[ $? -ne 0 ]]; then
      	mv /etc/x-ui/x-ui.db.bak /etc/x-ui/x-ui.db
      else
      	rm -f /etc/x-ui/x-ui.db.bak
      fi
      x-ui restart
      echo -e "${green}x-ui 配置已恢复${plain}\n"
    else
      echo -e "${yellow}保留 x-ui 当前配置${plain}\n"
    fi
  fi
}

if ! type x-ui &>/dev/null; then
  read -p "是否安装 x-ui？${Default}" answer
  if Option; then
    echo -e "开始安装 x-ui ...\n"
    bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
    x-ui_db
  else
    Cancel_info
  fi
else
  echo -e "${green}x-ui 已安装${plain}"
  x-ui_db
fi

# 安装Caddy
if ! type caddy &>/dev/null; then
  read -p "是否安装 Caddy？${Default}" answer
  if Option; then
    echo "正在安装 Caddy ..."
    # Caddy安装指令
    apt install -y debian-keyring debian-archive-keyring apt-transport-https
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
    apt update && apt install caddy
    echo -e "${green}Caddy 安装成功${plain}\n"
  else
    Cancel_info
  fi
else
  echo -e "${green}Caddy 已安装${plain}\n"
fi

# 安装Docker
if ! type docker &>/dev/null; then
  read -p "是否安装 Docker？${Default}" answer
  if Option; then
    echo "正在安装 Docker ..."
    # Docker安装指令
    curl -fsSL https://get.docker.com | bash
    Install_succ
  else
    Cancel_info
  fi
else
  echo -e "${green}Docker 已安装${plain}\n"
fi

# 安装Docker容器Portainer
install_portainer () {
  if ! docker ps | grep portainer &>/dev/null; then
    read -p "是否安装 Portainer？${Default}" answer
    if Option; then
      echo -e "开始安装 Portainer ...\n"
      docker volume create portainer_data
      docker run -d --network host --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
      echo -e "${green}Portainer 安装成功，${red}5分钟内${green}访问 http://IP:9000 进行初始化配置${plain}\n"
    else
      Cancel_info
    fi
  else
    echo -e "${green}Portainer 已安装${plain}\n"
  fi
}

if ! type docker &>/dev/null; then
  echo -e "安装 Portainer 容器前，${yellow}需先安装 Docker!${plain}"
  read -p "是否安装 Docker？${Default}" answer
  if Option; then
    echo -e "正在安装 Docker ...\n"
    curl -fsSL https://get.docker.com | bash
    echo ""
    if type docker &>/dev/null; then
      echo -e "进入 Portainer 安装脚本...\n"
      install_portainer
    else
      echo -e "${red}Docker 安装失败，退出 Portainer 容器安装!${plain}\n"
    fi
  else
    echo -e "${red}Docker 取消安装，退出 Portainer 容器安装!${plain}\n"
  fi
else
  install_portainer
fi

# 安装Docker容器Watchtower
install_watchtower() {
  if ! docker ps | grep watchtower &>/dev/null; then
    read -p "是否安装 Watchtower？${Default}" answer
    if Option; then
      echo -e "开始安装 Watchtower ...\n"
      docker run -d --name watchtower --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
      Install_succ
    else
      Cancel_info
    fi
  else
    echo -e "${green}Watchtower 已安装${plain}\n"
  fi
}

if ! type docker &>/dev/null; then
  echo -e "安装 Watchtower 容器前，${yellow}需先安装 Docker!${plain}"
  read -p "是否安装 Docker？${Default}" answer
  if Option; then
    echo -e "开始安装 Docker ...\n"
    curl -fsSL https://get.docker.com | bash
    echo ""
    if type docker &>/dev/null; then
      echo -e "进入 Watchtower 安装脚本...\n"
      install_watchtower
    else
      echo -e "${red}Docker 安装失败，退出 Watchtower 容器安装!${plain}\n"
    fi
  else
    echo -e "${red}Docker 取消安装，退出 Watchtower 容器安装!${plain}\n"
  fi
else
  install_watchtower
fi

# 安装Fail2ban
# 修改Fail2ban默认配置
config_fail2ban() {
  if type fail2ban-client &>/dev/null; then
    read -p "是否修改 Fail2ban 默认配置？${Default}" answer
    if Option; then
      echo -e "开始配置 Fail2ban ...\n"
      if [ -f /etc/fail2ban/jail.local ]; then
        echo -e "${yellow}jail.local 文件已存在${plain}\n"
      else
        # 复制默认的 jail.conf 文件
        cp /etc/fail2ban/jail.{conf,local}
        echo -e "${yellow}jail.local 文件已复制${plain}\n"
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
      echo -e "新的 bantime 值为：$new_bantime\n"
      sed -i "s/^bantime\s*=\s*$current_bantime/bantime = $new_bantime/1" $jail_file
  	echo "当前 findtime 值为：$current_findtime"
      read -p "请输入新的 findtime 值（回车保留默认值）：" new_findtime
      if [ -z "$new_findtime" ]; then
        new_findtime=$current_findtime
      fi
      echo -e "新的 findtime 值为：$new_findtime\n"
      sed -i "s/^findtime\s*=\s*$current_findtime/findtime = $new_findtime/1" $jail_file
  	echo "当前 maxretry 值为：$current_maxretry"
      read -p "请输入新的 maxretry 值（回车保留默认值）：" new_maxretry
      if [ -z "$new_maxretry" ]; then
        new_maxretry=$current_maxretry
      fi
      echo -e "新的 maxretry 值为：$new_maxretry\n"
      sed -i "s/^maxretry\s*=\s*$current_maxretry/maxretry = $new_maxretry/1" $jail_file
      # 启用SSHD Jail
      #sed -i '/^\[sshd\]/{n;/^\s*enabled\s*=/ {s/false/true/;t};s/$/\nenabled = true/}' $jail_file
      sed -i '/^\[sshd\]/{n;/enabled *= *true/!s/.*/&\nenabled = true/}' $jail_file
      # 重启 fail2ban 服务
      sudo systemctl restart fail2ban
      echo -e "${red}Fail2ban 配置已更新并重启${plain}\n"
    else
      echo -e "${yellow}保留默认配置${plain}\n"
    fi
  else
    echo ""
  fi
}

if ! type fail2ban-client &>/dev/null; then
  read -p "是否安装 Fail2ban？${Default}" answer
  if Option; then
    echo "开始安装 Fail2ban ..."
    apt-get -y install fail2ban
    Install_succ
    config_fail2ban
  else
    Cancel_info
  fi
else
  echo -e "${green}Fail2ban 已安装${plain}"
  config_fail2ban
fi

# 安装 Rust 版 ServerStatus 云探针
install_ServerStatus() {
  read -p "是否 安装/更新 客户端？${Default}" answer
  if Option; then
    read -p "请输入服务端域名/IP:端口：" url
    if [ -z "$url" ]; then
      url=https://vps.simpletechcn.com
    fi
    echo -e "新的服务端域名/IP:端口为：$url\n"
    read -p "请输入用户名：" username
    if [ -z "$username" ]; then
      username=uid
    fi
    echo -e "新的用户名为：$username\n"
    read -p "请输入密码：" password
    if [ -z "$password" ]; then
      password=pp
    fi
    echo -e "新的密码为：$password\n"
    read -p "是否启用 vnstat (0:不启用 / 默认1:启用)：" vnstat
    if [ -z "$vnstat" ]; then
      vnstat=1
    fi
    if [ "$vnstat" = "1" ]; then
      echo -e "${green}vnstat已启用${plain}\n"
    else
      echo -e "${red}vnstat不启用${plain}\n"
    fi
    curl -sSLf "${url}/i?pass=${password}&uid=${username}&vnstat=${vnstat}" | bash
    echo -e "${green}ServerStatus 云探针客户端已安装/更新${plain}\n"
  else
    echo -e "${red}取消 安装/更新 ServerStatus 云探针客户端${plain}\n"
  fi
}

if ! find /opt/ServerStatus/stat_client &>/dev/null; then
  echo -e "Rust 版 ServerStatus 云探针客户端${red}未安装${plain}"
  install_ServerStatus
else
  echo -e "Rust 版 ServerStatus 云探针客户端${green}已安装${plain}"
  install_ServerStatus
fi

# 安装Rclone
config_rclone() {
  if type rclone &>/dev/null; then
    read -p "是否配置 Rclone？${Default}" answer
    if Option; then
      rclone config
    else
      echo -e "${red}取消配置${plain}，后续输入${yellow} rclone config ${plain}进行配置\n"
    fi
  else
    echo ""
  fi
}

if ! type rclone &>/dev/null; then
  read -p "是否安装 Rclone？${Default}" answer
  if Option; then
    echo "开始安装 Rclone ..."
    curl https://rclone.org/install.sh | bash
    Install_succ
    config_rclone
  else
    Cancel_info
  fi
else
  echo -e "${green}Rclone 已安装${plain}"
  config_rclone
fi

# 检测定时清理磁盘空间任务是否已设置
if ! type /opt/cleandata.sh &>/dev/null; then
  read -p "是否设置定时清理磁盘空间任务？${Default}" answer
  if Option; then
    echo "正在设置定时清理磁盘空间任务..."
    wget --no-check-certificate -O /opt/cleandata.sh https://raw.githubusercontent.com/FrankLiangCN/init/main/cleandata.sh
    chmod +x /opt/cleandata.sh
    echo -e "${yellow}正在清理磁盘空间${plain}\n"
    bash /opt/cleandata.sh
    echo -e "${yellow}磁盘空间已清理${plain}"
    echo "0 0 */7 * *  bash /opt/cleandata.sh > /dev/null 2>&1" >> /var/spool/cron/crontabs/root
    #echo "0 0 */7 * *  root bash /opt/cleandata.sh > /dev/null 2>&1" >> /etc/crontab
    echo -e "${green}定时清理磁盘空间任务已设置${plain}\n"
  else
    echo -e "${red}取消设置${plain}\n"
  fi
else
  echo -e "${green}定时清理磁盘空间任务已设置${plain}\n"
fi

echo -e ""
echo -e "${yellow}=========================================================${plain}"
echo -e "${yellow}             Linux 环境初始化自动部署成功！              ${plain}"
echo -e "${yellow}=========================================================${plain}"
echo -e ""

# 修改Root密码
echo -e "修改 Root 密码后，${red}需断开所有连接重新登录后生效！！${plain}"
read -p "是否修改 Root 密码？${Default}" answer
if Option; then
  read -p "请输入新密码：" new_password
  if [ -z "$new_password" ]; then
    new_password=@Sz123456
  fi
  echo -e "新的 Root 密码为：$new_password"
  # 更改 root 密码
  echo "root:$new_password" | chpasswd
  sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
  service ssh restart
  # 检查是否成功更改密码
  if [ $? -eq 0 ]; then
    echo -e "Root 密码已成功更改为：$new_password\n"
    read -p "是否立即断开所有连接？${Default}" answer
    if Option; then
      echo -e "${red}自动断开所有连接，使用新 Root 密码重新登录${plain}"
      current_tty=$(tty)
      pts_list=$(who | awk '{print $2}')
      for pts in $pts_list; do
        [ "$current_tty" != "/dev/$pts" ]
        pkill -9 -t $pts
      done
    else
      echo -e "${red}需手动断开所有连接，使用新 Root 密码重新登录${plain}\n" 
    fi
  else
    echo -e "${red}更改 Root 密码失败${plain}\n"
  fi
else
  echo -e "${yellow}Root 密码未变更${plain}\n"
fi
