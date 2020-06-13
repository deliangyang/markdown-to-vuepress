FROM ubuntu:latest

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ADD bin/docs-web-build-cron /etc/cron.d/docs-web-build-cron

ADD . /docs-web

RUN apt-get update && apt-get -y install cron nginx nodejs npm

RUN npm config set registry https://registry.npm.taobao.org \
  && npm info underscore \
  && npm cache clean --force \
  && npm cache verify \
  && npm install -g vuepress

# 授权
# ADD nginx/docs.conf /etc/nginx/sites-available/default
# ADD nginx/.htpasswd /etc/apache2/.htpasswd

RUN chmod 0644 /etc/cron.d/docs-web-build-cron && \
    crontab /etc/cron.d/docs-web-build-cron && \
    touch /var/log/cron.log

ADD . /docs-web

RUN cd /docs-web && bin/deploy.sh

WORKDIR /docs-web

EXPOSE 8090

ENTRYPOINT nginx && cron && tail -f /dev/null
