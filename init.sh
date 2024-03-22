#!/bin/bash

echo ""
echo " ========================================================= "
echo " +              Linux 环境初始化自动部署脚本             + "
echo " ========================================================= "
echo ""


# 开启SSH密钥登录选项
# 检测PubkeyAuthentication参数
echo "正在设置SSH密钥登录选项"
pubkey_auth=$(sed -n 's/^PubkeyAuthentication\s*\(.*\)/\1/p' /etc/ssh/sshd_config)

# 如果PubkeyAuthentication参数为空值
if [ -z "$pubkey_auth" ]; then
  echo "PubkeyAuthentication 参数为空值，将添加 PubkeyAuthentication yes 和 RSAAuthentication yes 参数"
  echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
  echo "RSAAuthentication yes" >> /etc/ssh/sshd_config
  echo "SSH密钥登录选项已开启"
  echo ""
# 如果PubkeyAuthentication参数为no
elif [ "$pubkey_auth" = "no" ]; then
  echo "PubkeyAuthentication 参数为 no，将修改为 yes，并添加 RSAAuthentication yes 参数"
  sed -i 's/^PubkeyAuthentication\s*no/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
  echo "RSAAuthentication yes" >> /etc/ssh/sshd_config
  echo "SSH密钥登录选项已开启"
  echo ""
# 如果PubkeyAuthentication参数为yes
elif [ "$pubkey_auth" = "yes" ]; then
  echo "PubkeyAuthentication 参数已为 yes，将添加 RSAAuthentication yes 参数"
  echo "RSAAuthentication yes" >> /etc/ssh/sshd_config
  echo "SSH密钥登录选项已开启"
  echo ""
fi

# 重启 sshd 服务
service sshd restart

# 设置系统时区
timedatectl set-timezone Asia/Hong_Kong
echo "设置系统时区为 Asia/Hong_Kong 成功！"
echo ""

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

# 检测vim是否已安装
if ! type vim &>/dev/null; then
  echo "vim 未安装，正在安装..."
  apt install unzip -y
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

# 检测ddns-go是否已安装
if ! type ddns-go &>/dev/null; then
  echo "ddns-go 未安装，正在安装..."
  bash <(curl -Ls https://raw.githubusercontent.com/FrankLiangCN/DDNS/main/ddns.sh)
  echo "ddns-go 已安装，请访问 http://IP:9876 进行初始化配置"
  echo ""
else
  echo "ddns-go 已安装，请访问 http://IP:9876 进行配置"
  echo ""
fi

# 检测x-ui是否已安装
if ! type x-ui &>/dev/null; then
  echo "x-ui 未安装，正在安装..."
  bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
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
