#!/bin/bash

Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
UBlue='\033[4;34m'
Plain='\033[0m'

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
