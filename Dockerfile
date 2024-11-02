FROM ubuntu:22.04 as fetcher
ENV NVM_VERSION v0.39.5
RUN apt-get update && \
    apt-get install -y git && \
    git clone \
        --depth 1 \
        --branch $NVM_VERSION \
        https://github.com/nvm-sh/nvm.git

FROM jenkins/inbound-agent:alpine-jdk21 as jnlp

FROM jenkins/agent:latest-alpine-jdk21

ARG user=jenkins

USER root

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

RUN apk -U add git curl bash

ENV NVM_DIR=/opt/nvm
# don't store npm cache in the image
VOLUME ~/.npm

# copy the nvm
COPY --from=fetcher --chown=jenkins:jenkins nvm $NVM_DIR
# copy wrapper scripts
COPY bin /usr/local/bin

USER ${user}

RUN nvm install 8.17.0
RUN nvm use 8.17.0

RUN npm set unsafe-perm true

RUN node --version
RUN java --version
RUN which java

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
