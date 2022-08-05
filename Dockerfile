FROM jenkins/inbound-agent:alpine as jnlp

FROM node:12.22.12-alpine

RUN apk -U add openjdk11-jre git curl bash

RUN apk -U add zip perl-utils

RUN npm set unsafe-perm true

RUN npm install -g webpack@3.12.0

RUN npm install -g gzipper

RUN npm install -g jest

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
