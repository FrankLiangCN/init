#!/bin/bash

# 配置可执行
# chmod +x /opt/clean_alpine.sh

# 配置到crontab
# 0 0 */2 * *  bash /opt/clean_alpine.sh > /dev/null 2>&1


# 清理 apt-get 缓存
apk cache clean
echo "apk 缓存已清理"
echo ""


#/tmp --设置查找的目录；
#-mtime +30 --设置修改时间为30天前；
#-type f --设置查找的类型为文件；其中f为文件，d则为文件夹
#-name "*" --设置文件名称，可以使用通配符；
#-exec rm -rf --查找完毕后执行删除操作；
# {} \; --固定写法

# 清理 7 天前的日志
find /var/log -mtime +7 -type f -name "*" -exec rm -rf {} \;
echo "日志已清理"
echo ""

# 清理 7 天前的临时文件
find /tmp -mtime +7 -type f -name "*" -exec rm -rf {} \;
echo "临时文件已清理"
echo ""
