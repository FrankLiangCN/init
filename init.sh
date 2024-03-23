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

# 判断参数并修改配置
if [ "$pubkey_authentication" = "no" ] && [ "$rsa_authentication" = "no" ]; then
  echo "修改PubkeyAuthentication和RSAAuthentication参数为yes..."
  sed -i 's/^\s*PubkeyAuthentication\s*no/PubkeyAuthentication yes/g' $ssh_config_file
  sed -i 's/^\s*RSAAuthentication\s*no/RSAAuthentication yes/g' $ssh_config_file
  echo "SSH密钥登录选项已开启"
  # 重启SSHD服务
  service sshd restart
  echo "SSHD服务已重启"
  echo ""
elif [ "$pubkey_authentication" = "yes" ] && [ "$rsa_authentication" = "no" ]; then
  echo "修改RSAAuthentication参数为yes..."
  sed -i 's/^\s*RSAAuthentication\s*no/RSAAuthentication yes/g' $ssh_config_file
  echo "SSH密钥登录选项已开启"
  # 重启SSHD服务
  service sshd restart
  echo "SSHD服务已重启"
  echo ""
elif [ "$pubkey_authentication" = "yes" ] && [ -z "$rsa_authentication" ]; then
  echo "增加RSAAuthentication yes..."
  echo "RSAAuthentication yes" >> $ssh_config_file
  echo "SSH密钥登录选项已开启"
  # 重启SSHD服务
  service sshd restart
  echo "SSHD服务已重启"
  echo ""
elif [ -z "$pubkey_authentication" ] && [ -z "$rsa_authentication" ]; then
  echo "增加PubkeyAuthentication yes和RSAAuthentication yes..."
  echo "PubkeyAuthentication yes" >> $ssh_config_file
  echo "RSAAuthentication yes" >> $ssh_config_file
  echo "SSH密钥登录选项已开启"
  # 重启SSHD服务
  service sshd restart
  echo "SSHD服务已重启"
  echo ""
else
  echo "SSH密钥登录选项已开启，无需修改配置..."
  echo ""
fi


# 设置系统时区
# 获取当前时区
current_timezone=$(date +%Z)

# 判断当前时区是否为Asia/Hong_Kong
if [ "$current_timezone" != "HKT" ]; then
  # 设置时区为Asia/Hong_Kong
  timedatectl set-timezone "Asia/Hong_Kong"
  echo "设置系统时区为 Asia/Hong_Kong 成功！"
  echo ""
else
  # 输出信息
  echo "当前时区已设置为Asia/Hong_Kong，无需修改"
  echo ""
fi

# apt 更新
echo "apt updating ..."
apt update >/dev/null 2>&1
echo "apt 已更新"
echo ""

# 检测curl是否已安装
if ! type curl &>/dev/null; then
  echo "curl 未安装，正在安装..."
  apt install curl -y
  echo "curl 已安装"
  echo ""
else
  echo "curl 已安装"
  echo ""
fi

# 检测wget是否已安装
if ! type wget &>/dev/null; then
  echo "wget 未安装，正在安装..."
  apt install wget -y
  echo "wget 已安装"
  echo ""
else
  echo "wget 已安装"
  echo ""
fi

# 检测unzip是否已安装
if ! type unzip &>/dev/null; then
  echo "unzip 未安装，正在安装..."
  apt install unzip -y
  echo "unzip 已安装"
  echo ""
else
  echo "unzip 已安装"
  echo ""
fi

# 检测nano是否已安装
if ! type nano &>/dev/null; then
  echo "nano 未安装，正在安装..."
  apt install nano -y
  echo "nano 已安装"
  echo ""
else
  echo "nano 已安装"
  echo ""
fi

# 检测vim是否已安装
if ! type vim &>/dev/null; then
  echo "vim 未安装，正在安装..."
  apt install vim -y
  echo "vim 已安装"
  echo ""
else
  echo "vim 已安装"
  echo ""
fi

# 检测vnstat是否已安装
if ! type vnstat &>/dev/null; then
  echo "vnstat 未安装，正在安装..."
  apt install vnstat -y
  echo "vnstat 已安装"
  echo ""
else
  echo "vnstat 已安装"
  echo ""
fi

# 检测清理磁盘空间任务是否已设置
if ! type /opt/cleandata.sh &>/dev/null; then
  echo "正在设置定时清理磁盘空间任务..."
  wget --no-check-certificate -O /opt/cleandata.sh https://raw.githubusercontent.com/FrankLiangCN/init/main/cleandata.sh
  chmod +x /opt/cleandata.sh
  #echo "0 0 */7 * *  bash /opt/cleandata.sh > /dev/null 2>&1" >> /var/spool/cron/crontabs/root
  echo "0 0 */7 * *  bash /opt/cleandata.sh > /dev/null 2>&1" >> /etc/crontab
  echo "定时清理磁盘空间任务已设置"
  echo ""
else
  echo "定时清理磁盘空间任务已设置"
  echo ""
fi

# 检测ddns-go是否已安装
if ! type ddns-go &>/dev/null; then
  echo "ddns-go未安装，是否安装？ (y/n)"
  read answer
  if [ "$answer" = "y" ]; then
    echo "开始安装ddns-go..."
    bash <(curl -sSL https://raw.githubusercontent.com/FrankLiangCN/DDNS/main/ddns.sh)
    echo "ddns-go 已安装，请访问 http://IP:9876 进行初始化配置"
    echo ""
  else
    echo "取消安装"
    echo ""
  fi
else
  echo "ddns-go 已安装，请访问 http://IP:9876 进行配置"
  echo ""
fi

# 检测x-ui是否已安装
if ! type x-ui &>/dev/null; then
  echo "x-ui未安装，是否安装？ (y/n)"
  read answer
  if [ "$answer" = "y" ]; then
    echo "开始安装x-ui..."
    bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
    echo ""
  else
    echo "取消安装"
    echo ""
  fi
else
  echo "x-ui 已安装"
  echo ""
fi


# 检测是否已经安装Caddy
if ! type caddy &>/dev/null; then
  echo "Caddy未安装，是否安装？ (y/n)"
  read answer
  if [ "$answer" = "y" ]; then
    echo "开始安装Caddy..."
    # Caddy安装指令
    apt install -y debian-keyring debian-archive-keyring apt-transport-https
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
    apt update && apt install caddy
    echo "Caddy安装成功"
    echo ""
  else
    echo "取消安装"
    echo ""
  fi
else
  echo "Caddy已安装"
  echo ""
fi


# 检测是否已经安装Docker
if ! type docker &>/dev/null; then
  echo "Docker未安装，是否安装？ (y/n)"
  read answer
  if [ "$answer" = "y" ]; then
    echo "开始安装Docker..."
    # Docker安装指令
    curl -fsSL https://get.docker.com | bash
    echo "Docker安装成功"
    echo ""
  else
    echo "取消安装"
    echo ""
  fi
else
  echo "Docker已安装"
  echo ""
fi

# 检测是否已经安装Docker容器portainer
if ! docker ps | grep portainer &>/dev/null; then
  echo "安装Portainer容器前，需先安装Docker"
  echo "Portainer未安装，是否安装？ (y/n)"
  read answer
  if [ "$answer" = "y" ]; then
    echo "开始安装Portainer..."
    # Portainer安装指令
    docker volume create portainer_data
    docker run -d --network host --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
    echo "Portainer安装成功，5分钟内访问 http://IP:9000 进行初始化配置"
    echo ""
  else
    echo "取消安装"
    echo ""
  fi
else
  echo "Portainer已安装"
  echo ""
fi

echo "Linux 环境初始化自动部署成功！"
echo ""
