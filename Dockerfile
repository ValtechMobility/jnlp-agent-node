FROM ghcr.io/valtechmobility/jnlp-agent-nvm:latest

RUN nvm install --default 8.17.0

RUN node --version
