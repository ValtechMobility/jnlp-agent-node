FROM jenkins/inbound-agent:alpine as jnlp

FROM node:12.22.12-alpine

RUN apk -U add openjdk11-jre git curl bash

RUN apk -U add zip perl-utils

RUN npm set unsafe-perm true

RUN npm install -g webpack@3.12.0

RUN npm install -g gzipper

RUN npm install -g jest

RUN \
  echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk --no-cache  update \
  && apk --no-cache  upgrade \
  && apk add --no-cache --virtual .build-deps \
    gifsicle pngquant optipng libjpeg-turbo-utils \
    udev ttf-opensans chromium \
  && rm -rf /var/cache/apk/* /tmp/*

ENV CHROME_BIN=/usr/bin/chromium-browser
ENV LIGHTHOUSE_CHROMIUM_PATH=/usr/bin/chromium-browser

#install  Angular CLI 9
RUN npm install -g @angular/cli@9.1.2

RUN apk add --no-cache --virtual .gyp python make g++

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
