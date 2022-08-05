FROM jenkins/inbound-agent:alpine as jnlp

FROM node:12.22.12-alpine

RUN apk -U add openjdk11-jre git curl bash

RUN apk -U add zip perl-utils

RUN npm set unsafe-perm true

RUN npm install -g webpack@3.12.0

RUN npm install -g gzipper

RUN npm install -g jest

RUN apk -U add --no-cache bash zip make gcc g++ python linux-headers paxctl gnupg
RUN apk -U add --no-cache openssl libc6-compat curl git chromium chromium-chromedriver xvfb

ENV CHROME_BIN /usr/bin/chromium-browser
ENV LIGHTHOUSE_CHROMIUM_PATH /usr/bin/chromium-browser

RUN npm install -g @angular/cli@9.1.2

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
