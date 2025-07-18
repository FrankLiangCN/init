#  Linux 环境初始化自动部署脚本

## 一键初始化

### A. 一键脚本：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/init.sh)
```
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/init_menu.sh)
```


#### B. 设置系统时区：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/timezone.sh)
```

#### C. 开启 SSH Key 登录：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/ssh_key.sh)
```

#### D. 安装常用软件：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/soft.sh)
```

#### E. 配置 NAT64：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/nat64.sh)
```

#### F. DDNS：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/ddns.sh)
```

#### G. X-UI：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/x-ui.sh)
```
##### a) 安装x-ui指定版本：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/x-ui_version.sh)
```
#### H. 安装 Caddy：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/caddy.sh)
```

#### I. Docker & Cotainer：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/docker_container.sh)
```

#### J. Fail2ban：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/fail2ban.sh)
```

#### K. 安装/配置 ufw：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/ufw.sh)
```
##### a) ufw 开放端口：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/ufw_allow_port.sh)
```

#### L. 安装 Rust 版 ServerStatus 云探针：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/server_status.sh)
```

#### M. 安装 Rclone：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/rclone.sh)
```

#### N. 安装 Tailscale：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/tailscale.sh)
```

#### O. 清理磁盘空间：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/clean.sh)
```

#### P. 修改 Root 密码：
```
bash <(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/script/change_passwd.sh)
```

#### Q. 安装 Oh My Zsh：
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
```
sh -c "$(curl -fsSL https://install.ohmyz.sh/)"
```
##### a) Oh My Zsh 配置：
```
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/omz/init_omz.zsh)"
```
##### b) 安装 Oh My Zsh 插件：
```
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/FrankLiangCN/init/main/omz/zsh_plugins.zsh)"
```
##### c) 使配置生效：
```
source ~/.zshrc
```
##### d) Change Default Shell:
```
chsh -s $(which zsh)
```
