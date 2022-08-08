FROM jenkins/inbound-agent:alpine as jnlp

FROM node:8.17.0-alpine

RUN apk -U add openjdk11-jre git curl bash

RUN npm set unsafe-perm true

RUN apk --no-cache add perl-dev

RUN apk add --no-cache --update \
    python \
    python-dev \
    build-base

RUN apk --no-cache add chromium=81.0.4044.113-r0
ENV CHROME_BIN /usr/bin/chromium-browser

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
