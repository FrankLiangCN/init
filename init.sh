#!/bin/bash

echo ""
echo " ========================================================= "
echo " +              Linux 环境初始化自动部署脚本             + "
echo " ========================================================= "
echo ""


# 开启SSH密钥登录选项
# 定义SSH配置文件路径
ssh_config_file="/etc/ssh/sshd_config"

# 检测PubkeyAuthentication参数
pubkey_authentication=$(grep -E "^\s*PubkeyAuthentication\s+" $ssh_config_file | awk '{print $2}')

# 检测RSAAuthentication参数
rsa_authentication=$(grep -E "^\s*RSAAuthentication\s+" $ssh_config_file | awk '{print $2}')

# 判断SSH参数并修改配置
if [ "$pubkey_authentication" = "no" ] && [ "$rsa_authentication" = "no" ]; then
  echo "修改 PubkeyAuthentication 和 RSAAuthentication 参数为 yes..."
  sed -i 's/^\s*PubkeyAuthentication\s*no/PubkeyAuthentication yes/g' $ssh_config_file
  sed -i 's/^\s*RSAAuthentication\s*no/RSAAuthentication yes/g' $ssh_config_file
  echo "SSH密钥登录选项已开启"
  # 重启SSH服务
  service ssh restart
  echo -e "SSH服务已重启\n"
elif [ "$pubkey_authentication" = "yes" ] && [ "$rsa_authentication" = "no" ]; then
  echo "修改 RSAAuthentication 参数为yes..."
  sed -i 's/^\s*RSAAuthentication\s*no/RSAAuthentication yes/g' $ssh_config_file
  echo "SSH密钥登录选项已开启"
  # 重启SSH服务
  service ssh restart
  echo -e "SSH服务已重启\n"
elif [ "$pubkey_authentication" = "yes" ] && [ -z "$rsa_authentication" ]; then
  echo "增加 RSAAuthentication yes..."
  echo "RSAAuthentication yes" >> $ssh_config_file
  echo "SSH密钥登录选项已开启"
  # 重启SSH服务
  service ssh restart
  echo -e "SSH服务已重启\n"
elif [ "$pubkey_authentication" = "no" ] && [ -z "$rsa_authentication" ]; then
  echo "修改 PubkeyAuthentication 参数为 yes 和 增加 RSAAuthentication yes..."
  sed -i 's/^\s*PubkeyAuthentication\s*no/PubkeyAuthentication yes/g' $ssh_config_file
  echo "RSAAuthentication yes" >> $ssh_config_file
  echo "SSH密钥登录选项已开启"
  # 重启SSH服务
  service ssh restart
  echo -e "SSH服务已重启\n"
elif [ -z "$pubkey_authentication" ] && [ -z "$rsa_authentication" ]; then
  echo "增加 PubkeyAuthentication yes 和 RSAAuthentication yes..."
  echo "PubkeyAuthentication yes" >> $ssh_config_file
  echo "RSAAuthentication yes" >> $ssh_config_file
  echo "SSH密钥登录选项已开启"
  # 重启SSH服务
  service ssh restart
  echo -e "SSH服务已重启\n"
else
  echo -e "SSH密钥登录选项已开启，无需修改配置...\n"
fi

# 设置系统时区
# 获取当前时区
current_timezone=$(date +%Z)

# 判断当前时区是否为Asia/Hong_Kong
if [ "$current_timezone" != "HKT" ]; then
  # 设置时区为Asia/Hong_Kong
  timedatectl set-timezone "Asia/Hong_Kong"
  echo -e "设置系统时区为 Asia/Hong_Kong 成功！\n"
else
  # 输出信息
  echo -e "当前时区已设置为Asia/Hong_Kong，无需修改\n"
fi

# apt 更新
read -p "是否进行apt更新？（回车默认yes）(y/n):" answer
if [[ x"$answer" == x"y" || x"$answer" == x"Y" || x"$answer" == x"" ]]; then
  echo "apt updating ..."
  apt update >/dev/null 2>&1
  echo -e "apt 已更新\n"
else
  echo -e "取消 apt 更新\n"
fi

# 安装curl
if ! type curl &>/dev/null; then
  echo "正在安装 curl ..."
  apt install -y curl
  echo -e "curl 已安装\n"
else
  echo -e "curl 已安装\n"
fi

# 安装wget
if ! type wget &>/dev/null; then
  echo "正在安装 wget ..."
  apt install -y wget
  echo -e "wget 已安装\n"
else
  echo -e "wget 已安装\n"
fi

# 安装tar
if ! type tar &>/dev/null; then
  echo "正在安装 tar ..."
  apt install -y tar
  echo -e "tar 已安装\n"
else
  echo -e "tar 已安装\n"
fi

# 安装unzip
#if ! type unzip &>/dev/null; then
#  echo "正在安装 unzip ..."
#  apt install -y unzip
#  echo -e "unzip 已安装\n"
#else
#  echo -e "unzip 已安装\n"
#fi

# 安装vim
if ! type vim &>/dev/null; then
  echo "正在安装 vim ..."
  apt install -y vim
  echo -e "vim 已安装\n"
else
  echo -e "vim 已安装\n"
fi

# 安装nano
if ! type nano &>/dev/null; then
  echo "正在安装 nano ..."
  apt install -y nano
  echo -e "nano 已安装\n"
else
  echo -e "nano 已安装\n"
fi

# 安装vnstat
if ! type vnstat &>/dev/null; then
  echo "正在安装 vnstat ..."
  apt install -y vnstat
  echo -e "vnstat 已安装\n"
else
  echo -e "vnstat 已安装\n"
fi

# 安装ddns-go
if ! type ddns-go &>/dev/null; then
  read -p "是否安装 ddns-go？（回车默认yes）(y/n):" answer
  if [[ x"$answer" == x"y" || x"$answer" == x"Y" || x"$answer" == x"" ]]; then
    echo "开始安装 ddns-go ..."
    bash <(curl -sSL https://raw.githubusercontent.com/FrankLiangCN/DDNS/main/ddns.sh)
    echo -e "ddns-go 已安装，请访问 http://IP:9876 进行初始化配置\n"
  else
    echo -e "取消安装\n"
  fi
else
  echo -e "ddns-go 已安装，请访问 http://IP:9876 进行配置\n"
fi

# 安装x-ui
if ! type x-ui &>/dev/null; then
  read -p "是否安装 x-ui？（回车默认yes）(y/n):" answer
  if [[ x"$answer" == x"y" || x"$answer" == x"Y" || x"$answer" == x"" ]]; then
    echo -e "开始安装 x-ui ...\n"
    bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
  else
    echo -e "取消安装\n"
  fi
else
  echo -e "x-ui 已安装\n"
fi

# 安装Caddy
if ! type caddy &>/dev/null; then
  read -p "是否安装 Caddy？（回车默认yes）(y/n):" answer
  if [[ x"$answer" == x"y" || x"$answer" == x"Y" || x"$answer" == x"" ]]; then
    echo "正在安装 Caddy ..."
    # Caddy安装指令
    apt install -y debian-keyring debian-archive-keyring apt-transport-https
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
    apt update && apt install caddy
    echo -e "Caddy 安装成功\n"
  else
    echo -e "取消安装\n"
  fi
else
  echo -e "Caddy 已安装\n"
fi

# 安装Docker
if ! type docker &>/dev/null; then
  read -p "是否安装 Docker？（回车默认yes）(y/n):" answer
  if [[ x"$answer" == x"y" || x"$answer" == x"Y" || x"$answer" == x"" ]]; then
    echo "正在安装 Docker ..."
    # Docker安装指令
    curl -fsSL https://get.docker.com | bash
    echo -e "Docker 安装成功\n"
  else
    echo -e "取消安装\n"
  fi
else
  echo -e "Docker 已安装\n"
fi

# 安装Docker容器Portainer
install_portainer () {
  if ! docker ps | grep portainer &>/dev/null; then
    read -p "是否安装 Portainer？（回车默认yes）(y/n):" answer
    if [[ x"$answer" == x"y" || x"$answer" == x"Y" || x"$answer" == x"" ]]; then
      echo -e "开始安装 Portainer ...\n"
      docker volume create portainer_data
      docker run -d --network host --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
      echo -e "Portainer 安装成功，5分钟内访问 http://IP:9000 进行初始化配置\n"
    else
      echo -e "Portainer 取消安装\n"
    fi
  else
    echo -e "Portainer 已安装\n"
  fi
}

if ! type docker &>/dev/null; then
  echo -e "安装 Portainer 容器前，需先安装 Docker!\n"
  read -p "是否安装 Docker？（回车默认yes）(y/n):" answer
  if [[ x"$answer" == x"y" || x"$answer" == x"Y" || x"$answer" == x"" ]]; then
    echo -e "正在安装 Docker ...\n"
    curl -fsSL https://get.docker.com | bash
    echo ""
    if type docker &>/dev/null; then
      echo -e "进入 Portainer 安装脚本...\n"
      install_portainer
    else
      echo -e "Docker 安装失败，退出 Portainer 容器安装!\n"
    fi
  else
    echo -e "Docker 取消安装，退出 Portainer 容器安装!\n"
  fi
elif type docker &>/dev/null; then
  install_portainer
else
  echo -e "Portainer 已安装\n"
fi

# 安装Docker容器Watchtower
install_watchtower() {
  if ! docker ps | grep watchtower &>/dev/null; then
    read -p "是否安装 Watchtower？（回车默认yes）(y/n):" answer
    if [[ x"$answer" == x"y" || x"$answer" == x"Y" || x"$answer" == x"" ]]; then
      echo -e "开始安装 Watchtower ...\n"
      docker run -d --name watchtower --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
      echo -e "Watchtower 安装成功\n"
    else
      echo -e "Watchtower 取消安装\n"
    fi
  else
    echo -e "Watchtower 已安装\n"
  fi
}

if ! type docker &>/dev/null; then
  echo -e "安装 Watchtower 容器前，需先安装 Docker!\n"
  read -p "是否安装 Docker？（回车默认yes）(y/n):" answer
  if [[ x"$answer" == x"y" || x"$answer" == x"Y" || x"$answer" == x"" ]]; then
    echo -e "开始安装 Docker ...\n"
    curl -fsSL https://get.docker.com | bash
    echo ""
    if type docker &>/dev/null; then
      echo -e "进入 Watchtower 安装脚本...\n"
      install_watchtower
    else
      echo -e "Docker 安装失败，退出 Watchtower 容器安装!\n"
    fi
  else
    echo -e "Docker 取消安装，退出 Watchtower 容器安装!\n"
  fi
elif type docker &>/dev/null; then
  install_watchtower
else
  echo -e "Watchtower 已安装\n"
fi

# 安装Fail2ban
# 修改Fail2ban默认配置
config_fail2ban() {
  if type fail2ban-client &>/dev/null; then
    read -p "是否修改 Fail2ban 默认配置？（回车默认yes）(y/n):" answer
    if [[ x"$answer" == x"y" || x"$answer" == x"Y" || x"$answer" == x"" ]]; then
      echo -e "开始配置 Fail2ban ...\n"
      if [ -f /etc/fail2ban/jail.local ]; then
        echo -e "jail.local 文件已存在\n"
      else
        # 复制默认的 jail.conf 文件
        cp /etc/fail2ban/jail.{conf,local}
        echo -e "jail.local 文件已复制\n"
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
      # 重启 fail2ban 服务
      sudo systemctl restart fail2ban
      echo -e "Fail2ban 配置已更新并重启。\n"
    else
      echo -e "保留默认配置\n"
    fi
  else
    echo ""
  fi
}

if ! type fail2ban-client &>/dev/null; then
  read -p "是否安装 Fail2ban？（回车默认yes）(y/n):" answer
  if [[ x"$answer" == x"y" || x"$answer" == x"Y" || x"$answer" == x"" ]]; then
    echo "开始安装 Fail2ban ..."
    apt-get -y install fail2ban
    echo -e "Fail2ban 安装成功\n"
    config_fail2ban
  else
    echo -e "取消安装\n"
  fi
elif type fail2ban-client &>/dev/null; then
  echo -e "Fail2ban 已安装"
  config_fail2ban
else
  echo -e "Fail2ban 已安装并已配置\n"
fi

# 检测定时清理磁盘空间任务是否已设置
if ! type /opt/cleandata.sh &>/dev/null; then
  read -p "是否设置定时清理磁盘空间任务？（回车默认yes）(y/n):" answer
  if [[ x"$answer" == x"y" || x"$answer" == x"Y" || x"$answer" == x"" ]]; then
    echo "正在设置定时清理磁盘空间任务..."
    wget --no-check-certificate -O /opt/cleandata.sh https://raw.githubusercontent.com/FrankLiangCN/init/main/cleandata.sh
    chmod +x /opt/cleandata.sh
    echo "0 0 */7 * *  bash /opt/cleandata.sh > /dev/null 2>&1" >> /var/spool/cron/crontabs/root
    #echo "0 0 */7 * *  root bash /opt/cleandata.sh > /dev/null 2>&1" >> /etc/crontab
    echo -e "定时清理磁盘空间任务已设置\n"
  else
    echo -e "取消设置\n"
  fi
else
  echo -e "定时清理磁盘空间任务已设置\n"
fi

# 安装 Rust 版 ServerStatus 云探针
install_ServerStatus() {
  read -p "是否 安装/更新 客户端？（回车默认yes）(y/n):" answer
  if [[ x"$answer" == x"y" || x"$answer" == x"Y" || x"$answer" == x"" ]]; then
    read -p "请输入服务端域名/IP:端口：" url
    if [ -z "$url" ]; then
      url=https://xxx_Or_http://xxx:8888
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
    curl -sSLf "${url}/i?pass=${password}&uid=${username}&vnstat=1" | bash
    echo -e "ServerStatus 云探针客户端已安装/更新\n"
  else
    echo -e "取消安装/更新 ServerStatus 云探针客户端\n"
  fi
}

if ! find /opt/ServerStatus/stat_client &>/dev/null; then
  echo -e "Rust 版 ServerStatus 云探针客户端未安装"
  install_ServerStatus
else
  echo -e "Rust 版 ServerStatus 云探针客户端已安装"
  install_ServerStatus
fi

echo -e "Linux 环境初始化自动部署成功！\n"
