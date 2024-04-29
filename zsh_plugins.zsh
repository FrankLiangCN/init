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

Cancel_info() {
  echo -e "${Red}取消安装${Plain}\n"
}

Install_succ() {
  echo -e "${Green}安装成功${Plain}\n"
}


# zsh-autosuggestions
if [[ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
  echo -e "${Green}zsh-autosuggestions 插件已安装${Plain}"
  echo -e "是否更新插件？${Default} "
  read answer
  if Option; then
    echo -e "${Yellow}正在安装 oh-my-zsh plugins ...${Plain}"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    if [[ $? -eq 0 ]]; then
      echo -e "${Green}zsh-autosuggestions 安装成功${Plain}\n"
    else
      echo -e "${Red}zsh-autosuggestions 安装失败${Plain}\n"
    fi
  else
    Cancel_info
  fi
else
    echo -e "${Yellow}正在安装 oh-my-zsh plugins ...${Plain}"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    if [[ $? -eq 0 ]]; then
      echo -e "${Green}zsh-autosuggestions 安装成功${Plain}\n"
    else
      echo -e "${Red}zsh-autosuggestions 安装失败${Plain}\n"
    fi
fi

# zsh-syntax-highlighting

if [[ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
  echo -e "${Green}zsh-syntax-highlighting 插件已安装${Plain}"
  echo -e "是否更新插件？${Default} "
  read answer
  if Option; then
    echo -e "${Yellow}正在安装 oh-my-zsh plugins ...${Plain}"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    if [[ $? -eq 0 ]]; then
      echo -e "${Green}zsh-syntax-highlighting 安装成功${Plain}\n"
    else
      echo -e "${Red}zsh-syntax-highlighting 安装失败${Plain}\n"
    fi
  else
    Cancel_info
  fi
else
    echo -e "${Yellow}正在安装 oh-my-zsh plugins ...${Plain}"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    if [[ $? -eq 0 ]]; then
      echo -e "${Green}zsh-syntax-highlighting 安装成功${Plain}\n"
    else
      echo -e "${Red}zsh-syntax-highlighting 安装失败${Plain}\n"
    fi
fi

source ~/.zshrc
