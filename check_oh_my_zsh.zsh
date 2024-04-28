#!/bin/zsh

Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
UBlue='\033[4;34m'
Plain='\033[0m'

# 定义项
Default='(y/n) [默认yes]:'

Update_succ() {
  echo -e "${Green}oh-my-zsh 配置更新成功${Plain}\n"
}

# 安装oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${Green}oh-my-zsh 已安装${Plain}"
    # 检查是否存在 .zshrc 文件
    if [ -f "$HOME/.zshrc" ]; then
        echo -e "${Green}.zshrc 文件已经存在${Plain}"
        echo -e "是否更新 .zshrc 文件？${Default} "
        read answer
        if [[ $answer =~ ^([Yy]|)$ ]]; then
            mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
            curl -fsSL "https://raw.githubusercontent.com/FrankLiangCN/init/main/.zshrc" -o "$HOME/.zshrc"
            if [ $? -eq 0 ]; then
                source "$HOME/.zshrc"
                rm -f ~/.zshrc.bak
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
        echo -e ".zshrc 文件不存在"
	    echo -e "正在下载 .zshrc 文件"
	    curl -fsSL "https://raw.githubusercontent.com/FrankLiangCN/init/main/.zshrc" -o "$HOME/.zshrc"
	    source "$HOME/.zshrc"
	    Update_succ
    fi
else
    echo -e "oh-my-zsh ${Red}未安装${Plain}"
    echo -e "${Yellow}请参考文档或手动安装: ${UBlue}https://github.com/ohmyzsh/ohmyzsh${Plain}\n"
fi
