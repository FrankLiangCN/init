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

# 开启SSH Key登录选项
# 定义SSH配置文件路径
ssh_config_file="/etc/ssh/sshd_config"

# 检测PubkeyAuthentication参数
pubkey_authentication=$(grep -E "^\s*PubkeyAuthentication\s+" $ssh_config_file | awk '{print $2}')

# 检测RSAAuthentication参数
rsa_authentication=$(grep -E "^\s*RSAAuthentication\s+" $ssh_config_file | awk '{print $2}')

# 恢复 SSH Key
Import_sshkey() {
#  if [ "$pubkey_authentication" = "yes" ] && [ "$rsa_authentication" = "yes" ]; then
    read -p "是否导入 SSH Key？${Default}" answer
    if Option; then
      read -p "输入SSH Key来源URL：" source_url
      if [ -z "${source_url}" ]; then
        source_url=https://sub.vsky.uk/sshkey
      fi
      echo -e "配置来源URL为：${Yellow}${source_url}${Plain}\n"
      read -p "输入配置来源路径：" path
      if [ -z "${path}" ]; then
        path=default
      fi
      echo -e "SSH Key来源路径为：${Yellow}${path}${Plain}\n"
      echo -e "${Yellow}开始导入 SSH Key...${Plain}\n"
      mv /root/.ssh/authorized_keys /root/.ssh/authorized_keys.bak
      curl -s -o /root/.ssh/authorized_keys ${source_url}/${path}/authorized_keys
      if [[ $? -ne 0 ]]; then
      	mv /root/.ssh/authorized_keys.bak /root/.ssh/authorized_keys
      else
      	rm -f /root/.ssh/authorized_keys.bak
      fi
      echo -e "${Green}SSH Key 已导入${Plain}\n"
    else
      echo -e "${Yellow}保留当前 SSH Key${Plain}\n"
    fi
#  fi
}

ssh_key_enable() {
  echo -e "SSH Key 登录选项${Green}已开启${Plain}\n"
  Import_sshkey
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
  Import_sshkey
fi
