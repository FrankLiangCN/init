#!/bin/bash

echo ""
echo " ========================================================= "
echo " +              Linux 环境初始化自动部署脚本             + "
echo " ========================================================= "
echo ""


## 开启SSH密钥登录选项
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
read -p "是否进行apt更新？ (y/n)": answer
if [[ x"$answer" == x"y" || x"$answer" == x"Y" ]]; then
  echo "apt updating ..."
  apt update >/dev/null 2>&1
  echo -e "apt已更新\n"
else
  echo -e "取消apt更新\n"
fi

# 检测curl是否已安装
if ! type curl &>/dev/null; then
  echo "curl未安装，正在安装..."
  apt install curl -y
  echo -e "curl已安装\n"
else
  echo -e "curl已安装\n"
fi

# 检测wget是否已安装
if ! type wget &>/dev/null; then
  echo "wget未安装，正在安装..."
  apt install wget -y
  echo -e "wget已安装\n"
else
  echo -e "wget已安装\n"
fi

# 检测tar是否已安装
if ! type tar &>/dev/null; then
  echo "tar未安装，正在安装..."
  apt install tar -y
  echo -e "tar已安装\n"
else
  echo -e "tar已安装\n"
fi

# 检测unzip是否已安装
if ! type unzip &>/dev/null; then
  echo "unzip未安装，正在安装..."
  apt install unzip -y
  echo -e "unzip已安装\n"
else
  echo -e "unzip已安装\n"
fi

# 检测nano是否已安装
if ! type nano &>/dev/null; then
  echo "nano未安装，正在安装..."
  apt install nano -y
  echo -e "nano已安装\n"
else
  echo -e "nano已安装\n"
fi

# 检测vim是否已安装
if ! type vim &>/dev/null; then
  echo "vim未安装，正在安装..."
  apt install vim -y
  echo -e "vim已安装\n"
else
  echo -e "vim已安装\n"
fi

# 检测vnstat是否已安装
if ! type vnstat &>/dev/null; then
  echo "vnstat未安装，正在安装..."
  apt install vnstat -y
  echo -e "vnstat已安装\n"
else
  echo -e "vnstat已安装\n"
fi

# 检测ddns-go是否已安装
if ! type ddns-go &>/dev/null; then
  read -p "ddns-go未安装，是否安装？ (y/n)": answer
  if [[ x"$answer" == x"y" || x"$answer" == x"Y" ]]; then
    echo "开始安装ddns-go..."
    bash <(curl -sSL https://raw.githubusercontent.com/FrankLiangCN/DDNS/main/ddns.sh)
    echo -e "ddns-go已安装，请访问 http://IP:9876 进行初始化配置\n"
  else
    echo -e "取消安装\n"
  fi
else
  echo -e "ddns-go已安装，请访问 http://IP:9876 进行配置\n"
fi

# 检测x-ui是否已安装
if ! type x-ui &>/dev/null; then
  read -p "x-ui未安装，是否安装？ (y/n)": answer
  if [[ x"$answer" == x"y" || x"$answer" == x"Y" ]]; then
    echo -e "开始安装x-ui...\n"
    bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
  else
    echo -e "取消安装\n"
  fi
else
  echo -e "x-ui已安装\n"
fi

# 检测是否已经安装Caddy
if ! type caddy &>/dev/null; then
  read -p "Caddy未安装，是否安装？ (y/n)": answer
  if [[ x"$answer" == x"y" || x"$answer" == x"Y" ]]; then
    echo "开始安装Caddy..."
    # Caddy安装指令
    apt install -y debian-keyring debian-archive-keyring apt-transport-https
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
    apt update && apt install caddy
    echo -e "Caddy安装成功\n"
  else
    echo -e "取消安装\n"
  fi
else
  echo -e "Caddy已安装\n"
fi

# 检测是否已经安装Docker
if ! type docker &>/dev/null; then
  read -p "Docker未安装，是否安装？ (y/n)": answer
  if [[ x"$answer" == x"y" || x"$answer" == x"Y" ]]; then
    echo "开始安装Docker..."
    # Docker安装指令
    curl -fsSL https://get.docker.com | bash
    echo -e "Docker安装成功\n"
  else
    echo -e "取消安装\n"
  fi
else
  echo -e "Docker已安装\n"
fi

# 检测是否已经安装Docker容器Portainer
if ! type docker &>/dev/null; then
  echo -e "安装Portainer容器前，需先安装Docker!\n"
  read -p "是否安装Docker？ (y/n)": answer
  if [[ x"$answer" == x"y" || x"$answer" == x"Y" ]]; then
    echo -e "开始安装Docker...\n"
    curl -fsSL https://get.docker.com | bash
    echo ""
    if type docker &>/dev/null; then
      echo -e "进入Portainer安装脚本...\n"
      if ! docker ps | grep portainer &>/dev/null; then
        read -p "Portainer未安装，是否安装？ (y/n)": answer
        if [[ x"$answer" == x"y" || x"$answer" == x"Y" ]]; then
          echo -e "开始安装Portainer...\n"
          docker volume create portainer_data
          docker run -d --network host --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
          echo -e "Portainer安装成功，5分钟内访问 http://IP:9000 进行初始化配置\n"
        else
          echo -e "Portainer取消安装\n"
        fi
      else
        echo -e "Portainer已安装\n"
      fi
    else
      echo -e "Docker安装失败，退出Portainer容器安装!\n"
    fi
  else
    echo -e "Docker取消安装，退出Portainer容器安装!\n"
  fi
elif type docker &>/dev/null; then
  if ! docker ps | grep portainer &>/dev/null; then
    read -p "Portainer未安装，是否安装？ (y/n)": answer
    if [[ x"$answer" == x"y" || x"$answer" == x"Y" ]]; then
      echo -e "开始安装Portainer...\n"
      docker volume create portainer_data
      docker run -d --network host --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
      echo -e "Portainer安装成功，5分钟内访问 http://IP:9000 进行初始化配置\n"
    else
      echo -e "Portainer取消安装\n"
    fi
  else
    echo -e "Portainer已安装\n"
  fi
else
  echo -e "Portainer已安装\n"
fi

# 检测是否已经安装Docker容器Watchtower
if ! type docker &>/dev/null; then
  echo -e "安装Watchtower容器前，需先安装Docker!\n"
  read -p "是否安装Docker？ (y/n)": answer
  if [[ x"$answer" == x"y" || x"$answer" == x"Y" ]]; then
    echo -e "开始安装Docker...\n"
    curl -fsSL https://get.docker.com | bash
    echo ""
    if type docker &>/dev/null; then
      echo -e "进入Watchtower安装脚本...\n"
      if ! docker ps | grep watchtower &>/dev/null; then
        read -p "Watchtower未安装，是否安装？ (y/n)": answer
        if [[ x"$answer" == x"y" || x"$answer" == x"Y" ]]; then
          echo -e "开始安装Watchtower...\n"
          docker run -d --name watchtower --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
          echo -e "Watchtower安装成功\n"
        else
          echo -e "Watchtower取消安装\n"
        fi
      else
        echo -e "Watchtower已安装\n"
      fi
    else
      echo -e "Docker安装失败，退出Watchtower容器安装!\n"
    fi
  else
    echo -e "Docker取消安装，退出Watchtower容器安装!\n"
  fi
elif type docker &>/dev/null; then
  if ! docker ps | grep watchtower &>/dev/null; then
    read -p "Watchtower未安装，是否安装？ (y/n)": answer
    if [[ x"$answer" == x"y" || x"$answer" == x"Y" ]]; then
      echo -e "开始安装Watchtower...\n"
      docker run -d --name watchtower --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
      echo -e "Watchtower安装成功\n"
    else
      echo -e "Watchtower取消安装\n"
    fi
  else
    echo -e "Watchtower已安装\n"
  fi
else
  echo -e "Watchtower已安装\n"
fi

# 检测定时清理磁盘空间任务是否已设置
if ! type /opt/cleandata.sh &>/dev/null; then
  read -p "是否设置定时清理磁盘空间任务？ (y/n)": answer
  if [[ x"$answer" == x"y" || x"$answer" == x"Y" ]]; then
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

echo -e "Linux 环境初始化自动部署成功！\n"
