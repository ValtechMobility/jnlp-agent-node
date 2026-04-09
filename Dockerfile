FROM ghcr.io/valtechmobility/jnlp-agent-nvm:latest

ARG user=jenkins

RUN nvm install --default 8.17.0

RUN node --version

RUN npm set unsafe-perm true

USER root

RUN echo "deb http://archive.debian.org/debian bullseye main" > /etc/apt/sources.list.d/bullseye.list

RUN apt update

RUN apt install -y python2.7

RUN npm config set python /usr/bin/python2.7

USER ${user}
