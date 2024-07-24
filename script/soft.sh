#!/bin/bash

Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
UBlue='\033[4;34m'
Plain='\033[0m'

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
    "git"
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
