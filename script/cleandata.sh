#!/bin/bash

# 配置可执行
# chmod +x /opt/script/cleandata.sh

# 配置到crontab
# 0 0 */2 * *  bash /opt/script/cleandata.sh > /dev/null 2>&1

Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
UBlue='\033[4;34m'
Plain='\033[0m'

# 清理 journal 日志
# 清理日志到只剩下 10M
#journalctl --vacuum-size=10M

# 清理一天前的日志
journalctl --vacuum-time=1d
echo -e "${Yellow}journal 日志已清理${Plain}\n"

# 清理 apt-get 缓存
apt-get clean
echo -e "${Yellow}apt-get 缓存已清理${Plain}\n"

#/tmp --设置查找的目录；
#-mtime +30 --设置修改时间为30天前；
#-type f --设置查找的类型为文件；其中f为文件，d则为文件夹
#-name "*" --设置文件名称，可以使用通配符；
#-exec rm -rf --查找完毕后执行删除操作；
# {} \; --固定写法

# 清理 1 天前的日志
find /var/log -mtime +1 -type f -name "*" -exec rm -rf {} \;
echo -e "${Yellow}1天前日志已清理${Plain}\n"

# 清理 1 天前的临时文件
find /tmp -mtime +1 -type f -name "*" -exec rm -rf {} \;
echo -e "${Yellow}1天前临时文件已清理${Plain}\n"
