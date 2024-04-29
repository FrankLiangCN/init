#!/bin/zsh

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

Update_succ() {
  echo -e "${Green}oh-my-zsh 配置更新成功${Plain}\n"
}

# 安装oh-my-zsh
# 检查是否存在 .zshrc 文件
if [ -f "$HOME/.zshrc" ]; then
  echo -e "${Green}.zshrc 文件已经存在${Plain}"
#  echo -e "是否更新 .zshrc 文件？${Default} "
  read -p "是否更新 .zshrc 文件？${Default} " answer
  if Option; then
    mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
    curl -fsSL "https://raw.githubusercontent.com/FrankLiangCN/init/main/.zshrc" -o "$HOME/.zshrc"
    sleep 2
    if [ $? -eq 0 ]; then
      source "$HOME/.zshrc"
      rm -f "$HOME/.zshrc.bak"
      Update_succ
    else
      echo -e "${Red}更新 .zshrc 文件失败，将恢复备份文件${Plain}"
      mv "$HOME/.zshrc.bak" "$HOME/.zshrc"
      source "$HOME/.zshrc"
      Update_succ
    fi
  else
    echo -e "${Yellow}保留当前配置${Plain}\n"
  fi
else
  echo -e "${Red}.zshrc 文件不存在${Plain}"
  echo -e "${Yellow}正在下载 .zshrc 文件...${Plain}"
  curl -fsSL "https://raw.githubusercontent.com/FrankLiangCN/init/main/.zshrc" -o "$HOME/.zshrc"
  sleep 2
  source "$HOME/.zshrc"
  Update_succ
fi
