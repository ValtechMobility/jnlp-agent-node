FROM jenkins/inbound-agent:alpine as jnlp

FROM node:20.18.0-alpine

RUN apk -U add openjdk11-jre git curl bash

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
RUN . "/root/.nvm/nvm.sh"

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
