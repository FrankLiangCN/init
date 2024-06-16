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

# 清理磁盘空间
if ! type /opt/cleandata.sh &>/dev/null; then
  read -p "是否设置定时清理磁盘空间任务？${Default}" answer
  if Option; then
    echo -e "${Yellow}正在设置定时清理磁盘空间任务...${Plain}"
    wget --no-check-certificate -O /opt/cleandata.sh https://raw.githubusercontent.com/FrankLiangCN/init/main/script/cleandata.sh
    chmod +x /opt/cleandata.sh
    echo -e "${Yellow}正在清理磁盘空间${Plain}\n"
    bash /opt/cleandata.sh
    echo -e "${Yellow}磁盘空间已清理${Plain}\n"
    echo "0 0 */3 * * bash /opt/cleandata.sh > /dev/null 2>&1" >> /var/spool/cron/crontabs/root
    #echo "0 0 */7 * * root bash /opt/cleandata.sh > /dev/null 2>&1" >> /etc/crontab
    echo -e "${Green}定时清理磁盘空间任务已设置${Plain}\n"
  else
    echo -e "${Red}取消设置${Plain}\n"
  fi
else
  read -p "是否更新清理磁盘空间任务脚本？${Default}" answer
  if Option; then
    echo -e "${Yellow}正在更新清理磁盘空间任务脚本...${Plain}"
    wget --no-check-certificate -O /opt/cleandata.sh https://raw.githubusercontent.com/FrankLiangCN/init/main/script/cleandata.sh
    echo -e "${Green}清理磁盘空间任务脚本已更新${Plain}\n"
  else
    echo -e "${Yellow}保留当前清理磁盘空间任务脚本${Plain}\n"
  fi
fi
