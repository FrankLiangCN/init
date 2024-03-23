#!/bin/bash

# 配置可执行
# chmod +x /opt/cleandata.sh

# 配置到crontab
# 0 0 */2 * *  bash /opt/cleandata.sh > /dev/null 2>&1


# 清理 journal 日志
	# 清理日志到只剩下 10M
#journalctl --vacuum-size=10M
	# 清理一天前的日志
journalctl --vacuum-time=1d

# 清理 apt-get 缓存
apt-get clean


#/tmp --设置查找的目录；
#-mtime +30 --设置修改时间为30天前；
#-type f --设置查找的类型为文件；其中f为文件，d则为文件夹
#-name "*" --设置文件名称，可以使用通配符；
#-exec rm -rf --查找完毕后执行删除操作；
# {} \; --固定写法

# 清理 7 天前的日志
find /var/log -mtime +7 -type f -name "*" -exec rm -rf {} \;

# 清理 7 天前的临时文件
find /tmp -mtime +7 -type f -name "*" -exec rm -rf {} \;
