FROM ghcr.io/valtechmobility/jnlp-agent-nvm:latest

RUN nvm install 8.17.0
RUN nvm use 8.17.0

RUN node --version
