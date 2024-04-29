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
#  echo -e "${Yellow}稍后需手动运行 ${UBlue}source ~/.zshrc${Yellow} 使新配置生效${Plain}"
}

Cancel_info() {
  echo -e "${Red}取消安装${Plain}\n"
}

# oh-my-zsh配置
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo -e "${Green}oh-my-zsh 已安装${Plain}"
  echo -e "是否安装 oh-my-zsh 插件？${Default}"
  read answer
  if Option; then
    # zsh-autosuggestions
    if [[ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
      echo -e "${Green}zsh-autosuggestions 插件已安装${Plain}\n"
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
      echo -e "${Green}zsh-syntax-highlighting 插件已安装${Plain}\n"
    else
      echo -e "${Yellow}正在安装 oh-my-zsh plugins ...${Plain}"
      git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
      if [[ $? -eq 0 ]]; then
        echo -e "${Green}zsh-syntax-highlighting 安装成功${Plain}\n"
      else
        echo -e "${Red}zsh-syntax-highlighting 安装失败${Plain}\n"
      fi
    fi
  else
    Cancel_info
  fi

  # 检查是否存在 .zshrc 配置文件
  if [ -f "$HOME/.zshrc" ]; then
    echo -e "${Green}.zshrc 配置文件已经存在${Plain}"
    echo -e "是否更新 .zshrc 配置文件？${Default} "
    read answer
    if Option; then
      mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
      curl -fsSL "https://raw.githubusercontent.com/FrankLiangCN/init/main/.zshrc" -o "$HOME/.zshrc"
      if [ $? -eq 0 ]; then
        rm -f "$HOME/.zshrc.bak"
        Update_succ
      else
        echo -e "${Red}更新 .zshrc 配置文件失败，将恢复备份文件${Plain}"
        mv "$HOME/.zshrc.bak" "$HOME/.zshrc"
        Update_succ
      fi
    else
      echo -e "${Yellow}保留当前配置${Plain}\n"
    fi
  else
    echo -e "${Red}.zshrc 配置文件不存在${Plain}"
    echo -e "${Yellow}正在下载 .zshrc 配置文件...${Plain}"
    curl -fsSL "https://raw.githubusercontent.com/FrankLiangCN/init/main/.zshrc" -o "$HOME/.zshrc"
    Update_succ
  fi

  source ~/.zshrc
#  echo -e "${Green}.zshrc 配置文件已生效${Plain}"
  echo -e "${Yellow}稍后需手动运行 ${UBlue}source ~/.zshrc${Yellow} 使新配置生效${Plain}\n"
else
  echo -e "oh-my-zsh ${Red}未安装${Plain}"
  echo -e "${Yellow}请参考文档或手动安装: ${UBlue}https://github.com/ohmyzsh/ohmyzsh${Plain}\n"
fi
