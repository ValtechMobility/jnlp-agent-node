FROM jenkins/inbound-agent:alpine-jdk21 as jnlp

FROM jenkins/agent:latest-alpine-jdk21

ARG user=jenkins

USER root

RUN apk -U add git curl bash

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
RUN . "/root/.nvm/nvm.sh"

RUN nvm install 8.17.0
RUN nvm use 8.17.0

RUN npm set unsafe-perm true

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

USER ${user}

RUN node --version
RUN java --version
RUN which java

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
