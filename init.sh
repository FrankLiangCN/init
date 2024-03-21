#!/bin/bash

echo ""
echo " ========================================================= "
echo " \              Linux 环境初始化自动部署脚本             / "
echo " ========================================================= "
echo "\n"

# 迫于经常在新机器上配置各种环境，写了一个初始化安装脚本
# 此脚本将安装常见工具并配置vim/wget/curl/pip3/zsh等,默认只配置基本环境
# LEVEL= config/dev/hacker/full
# config主要就是配置zsh/vim/wget/cur等系统配置,然后安装一些常见的软件例如git htop ncdu vim等
# dev是安装开发环境java/python3/Go/Node/Docker
# hacker 安装常见的网络安全工具，例如sqlmap/nmap/httpx/subfinder/ffuf/xray等
# full 一把梭

LEVEL='full'


# 开启SSH密钥登录选项
# 检测PubkeyAuthentication参数
pubkey_auth=$(sed -n 's/^PubkeyAuthentication\s*\(.*\)/\1/p' /etc/ssh/sshd_config)

# 如果PubkeyAuthentication参数为空值
if [ -z "$pubkey_auth" ]; then
  echo "PubkeyAuthentication参数为空值，将添加PubkeyAuthentication yes 和 RSAAuthentication yes参数"
  echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
  echo "RSAAuthentication yes" >> /etc/ssh/sshd_config
  echo "SSH密钥登录选项已开启"
# 如果PubkeyAuthentication参数为no
elif [ "$pubkey_auth" = "no" ]; then
  echo "PubkeyAuthentication参数为no，将修改为yes"
  sed -i 's/^PubkeyAuthentication\s*no/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
  echo "SSH密钥登录选项已开启"
# 如果PubkeyAuthentication参数为yes
elif [ "$pubkey_auth" = "yes" ]; then
  echo "PubkeyAuthentication参数已为yes，将添加RSAAuthentication yes参数"
  echo "RSAAuthentication yes" >> /etc/ssh/sshd_config
  echo "SSH密钥登录选项已开启"
fi

# 重启 sshd 服务
service sshd restart

# 设置系统时区
timedatectl set-timezone Asia/Hong_Kong
echo "设置系统时区为 Asia/Hong_Kong成功！"

# apt 更新
echo "apt update ..."
apt update >/dev/null 2>&1

# 检测curl是否已安装
if ! type curl &>/dev/null; then
  echo "curl 未安装，正在安装..."
  apt install curl -y
else
  echo "curl 已安装"
fi

# 检测wget是否已安装
if ! type wget &>/dev/null; then
  echo "wget 未安装，正在安装..."
  apt install wget -y
else
  echo "wget 已安装"
fi

# 检测unzip是否已安装
if ! type unzip &>/dev/null; then
  echo "unzip 未安装，正在安装..."
  apt install unzip -y
else
  echo "unzip 已安装"
fi

# 检测vim是否已安装
if ! type vim &>/dev/null; then
  echo "vim 未安装，正在安装..."
  apt install unzip -y
else
  echo "vim 已安装"
fi

# 检测vnstat是否已安装
if ! type vnstat &>/dev/null; then
  echo "vnstat 未安装，正在安装..."
  apt install vnstat -y
else
  echo "vnstat 已安装"
fi

# 检测ddns-go是否已安装
if ! type ddns-go &>/dev/null; then
  echo "ddns-go 未安装，正在安装..."
  wget -qO- https://raw.githubusercontent.com/FrankLiangCN/DDNS/main/ddns.sh | bash
else
  echo "ddns-go 已安装"
fi

# 检测x-ui是否已安装
if ! type x-ui &>/dev/null; then
  echo "x-ui 未安装，正在安装..."
  bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
else
  echo "ddns-go 已安装"
fi

echo "Linux 环境初始化自动部署成功！"
