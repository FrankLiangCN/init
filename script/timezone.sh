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
  echo -e "${Red}取消同步系统时间${Plain}\n"
}

# 同步系统时间
ntp_time() {
  if Option; then
    echo -e "${Yellow}正在同步系统时间...${Plain}"

    # 检查ntpd是否可用，如果不可用则使用ntpdate
    if command -v ntpd &> /dev/null; then
      ntpd -d -q -n -p ntp.aliyun.com
    #ntpdate time.windows.com
    else
      echo -e "${Red}错误: 未找到ntpd命令${Plain}"
      echo -e "${Yellow}请先安装ntp工具包${Plain}"
      return 1
    fi
    
    if [ $? -eq 0 ]; then
      echo -e "${Green}系统时间同步成功！${Plain}\n"
    else
      echo -e "${Red}系统时间同步失败，请检查网络连接！${Plain}\n"
    fi
  else
    Cancel_info
  fi
}

# 设置系统时区
# 获取当前时区
#current_timezone=$(date +%Z)
current_timezone=$(timedatectl show --property=Timezone --value 2>/dev/null || echo "未知")

# 判断当前时区是否为Asia/Hong_Kong
#if [ "$current_timezone" != "HKT" ]; then
if [ "$current_timezone" != "Asia/Hong_Kong" ]; then
  echo -e "当前时区: ${Yellow}${current_timezone}${Plain}"
  echo -e "目标时区: ${Green}Asia/Hong_Kong${Plain}"

  # 设置时区为Asia/Hong_Kong
  timedatectl set-timezone "Asia/Hong_Kong"
  if [ $? -eq 0 ]; then
    echo -e "${Green}设置系统时区为 Asia/Hong_Kong 成功！${Plain}\n"
    read -p "是否同步系统时间？${Default}" answer
    ntp_time
  else
    echo -e "${Red}设置系统时区失败，请重新设置！${Plain}\n"
    exit 1
  fi
else
  echo -e "当前时区已设置为 ${Green}Asia/Hong_Kong${Plain}，无需修改\n"
  read -p "是否同步系统时间？${Default}" answer
  ntp_time
fi

# 显示最终时间状态
echo -e "\n${UBlue}最终时间配置:${Plain}"
timedatectl status
