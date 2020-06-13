#!/bin/bash

LOG_FILE="/var/log/docs-web.log"

echo "$(date '+%Y-%m-%d %H:%M:%S') 部署检测" >> $LOG_FILE


# 如果上一个命令还未执行完毕，则结束本次命令
if [ -n "$(ps -ef | grep bin/build.sh | grep -v grep)" ]; then
    exit 0
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') 开始部署" >> $LOG_FILE

cd /docs-web

# 编译部署
bin/build.sh

if [ ! -d "/docs-web/docs/.vuepress/dist" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') 部署失败" >> $LOG_FILE
    exit 1
fi

rm -rf /var/www/html/* && \
    cp -a /docs-web/docs/.vuepress/dist/* /var/www/html/ && \
    echo "$(date '+%Y-%m-%d %H:%M:%S') 部署成功" >> $LOG_FILE
