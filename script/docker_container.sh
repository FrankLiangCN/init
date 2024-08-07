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
  echo -e "${Red}取消安装${Plain}\n"
}

Install_succ() {
  echo -e "${Green}安装成功${Plain}\n"
}

# 安装Docker
if ! type docker &>/dev/null; then
  read -p "是否安装 Docker？${Default}" answer
  if Option; then
    echo -e "${Yellow}正在安装 Docker ...${Plain}"
    # Docker安装指令
    curl -fsSL https://get.docker.com | bash
    Install_succ
  else
    Cancel_info
  fi
else
  echo -e "${Green}Docker 已安装${Plain}\n"
  read -p "是否更新 Docker？${Default}" answer
  if Option; then
    echo -e "${Yellow}正在安装 Docker ...${Plain}"
    # Docker安装指令
    curl -fsSL https://get.docker.com | bash
    Install_succ
  else
    Cancel_info
  fi
fi

# 安装Docker容器Portainer
Install_portainer () {
  if ! docker ps | grep portainer &>/dev/null; then
    read -p "是否安装 Portainer？${Default}" answer
    if Option; then
      echo -e "${Yellow}开始安装 Portainer ...${Plain}\n"
      docker volume create portainer_data
      docker run -d --network host --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
      echo -e "${Green}Portainer 安装成功，${Red}5分钟内${Green}访问 ${UBlue}http://IP:9000${Green} 进行初始化配置${Plain}\n"
    else
      Cancel_info
    fi
  else
    echo -e "${Green}Portainer 已安装${Plain}\n"
  fi
}

if ! type docker &>/dev/null; then
  echo -e "安装 Portainer 容器前，${Yellow}需先安装 Docker!${Plain}"
  read -p "是否安装 Docker？${Default}" answer
  if Option; then
    echo -e "${Yellow}正在安装 Docker ...${Plain}\n"
    curl -fsSL https://get.docker.com | bash
    echo ""
    if type docker &>/dev/null; then
      echo -e "${Yellow}进入 Portainer 安装脚本...${Plain}\n"
      Install_portainer
    else
      echo -e "${Red}Docker 安装失败，退出 Portainer 容器安装!${Plain}\n"
    fi
  else
    echo -e "${Red}Docker 取消安装，退出 Portainer 容器安装!${Plain}\n"
  fi
else
  Install_portainer
fi

# 安装Docker容器Watchtower
Install_watchtower() {
  if ! docker ps | grep watchtower &>/dev/null; then
    read -p "是否安装 Watchtower？${Default}" answer
    if Option; then
      echo -e "${Yellow}开始安装 Watchtower ...${Plain}\n"
      docker run -d --name watchtower --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
      Install_succ
    else
      Cancel_info
    fi
  else
    echo -e "${Green}Watchtower 已安装${Plain}\n"
  fi
}

if ! type docker &>/dev/null; then
  echo -e "安装 Watchtower 容器前，${Yellow}需先安装 Docker!${Plain}"
  read -p "是否安装 Docker？${Default}" answer
  if Option; then
    echo -e "${Yellow}开始安装 Docker ...${Plain}\n"
    curl -fsSL https://get.docker.com | bash
    echo ""
    if type docker &>/dev/null; then
      echo -e "进入 Watchtower 安装脚本...\n"
      Install_watchtower
    else
      echo -e "${Red}Docker 安装失败，退出 Watchtower 容器安装!${Plain}\n"
    fi
  else
    echo -e "${Red}Docker 取消安装，退出 Watchtower 容器安装!${Plain}\n"
  fi
else
  Install_watchtower
fi

# 检测定时清理 Docker 容器日志任务是否已设置
if type docker &>/dev/null; then
  if ! type /opt/script/clean_docker_log.sh &>/dev/null; then
    read -p "是否设置定时清理 Docker 容器日志任务？${Default}" answer
    if Option; then
      echo -e "${Yellow}正在设置定时清理 Docker 容器日志任务...${Plain}"
      mkdir -p /opt/script
      wget --no-check-certificate -O /opt/script/clean_docker_log.sh https://raw.githubusercontent.com/FrankLiangCN/init/main/script/clean_docker_log.sh
      chmod +x /opt/script/clean_docker_log.sh
      echo "0 0 */7 * * bash /opt/script/clean_docker_log.sh > /dev/null 2>&1" >> /var/spool/cron/crontabs/root
      #echo "0 0 */7 * * root bash /opt/script/cleandata.sh > /dev/null 2>&1" >> /etc/crontab
      echo -e "${Green}定时清理 Docker 容器日志任务已设置${Plain}\n"
    else
      echo -e "${Red}取消设置${Plain}\n"
    fi
  else  
    read -p "是否更新清理 Docker 容器日志任务脚本？${Default}" answer
    if Option; then
      echo -e "${Yellow}正在更新清理 Docker 容器日志任务脚本...${Plain}"
      wget --no-check-certificate -O /opt/script/clean_docker_log.sh https://raw.githubusercontent.com/FrankLiangCN/init/main/script/clean_docker_log.sh
      echo -e "${Green}清理 Docker 容器日志任务脚本已更新${Plain}\n"
    else
      echo -e "${Yellow}保留当前清理 Docker 容器日志任务脚本${Plain}\n"
    fi
  fi
fi
