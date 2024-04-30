#  Linux 环境初始化自动部署脚本

## 一键初始化

### A. 一键脚本命令：
```
bash <(curl -sSL https://raw.githubusercontent.com/FrankLiangCN/init/main/init.sh)
```

### B. 安装 Oh My Zsh：
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
```
sh -c "$(curl -fsSL https://install.ohmyz.sh/)"
```
#### a) Oh My Zsh 配置：
```
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/init_omz.zsh)"
```
#### b) Change Your Default Shell:
```
chsh -s $(which zsh)
```
