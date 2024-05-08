#  Linux 环境初始化自动部署脚本

## 一键初始化

### A. 一键脚本：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/init.sh)
```

### B. 开启SSH Key登录：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/ssh_key.sh)
```

### C. DDNS：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/ddns.sh)
```

### D. X-UI：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/x-ui.sh)
```

### E. Docker & Cotainer：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/docker_container.sh)
```

### F. Fail2ban：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/fail2ban.sh)
```

### G. 安装 Rust 版 ServerStatus 云探针：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/server_status.sh)
```

### H. ufw开放端口：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/ufw_allow_port.sh)
```

### I. 安装 Oh My Zsh：
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
#### b) 使配置生效:
```
source ~/.zshrc
```
#### c) Change Your Default Shell:
```
chsh -s $(which zsh)
```
