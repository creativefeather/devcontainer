# syntax=docker/dockerfile:1

ARG BASE_IMAGE="python:3.12.3-bullseye"

### BASE ###
FROM --platform=${TARGETPLATFORM} ${BASE_IMAGE} AS base

LABEL maintainer="creativefeather <creativefeather@outlook.com>"
LABEL description="Provides the base image for all development and production images."
LABEL version="1.0"
LABEL vendor=""
LABEL url=""
LABEL license="MIT"

ARG TARGETPLATFORM

ENV LANG=C.UTF-8
ENV PROJECT_DIR=/app

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    # Clean up
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN curl https://pyenv.run | bash \
    && echo 'export PATH="/root/.pyenv/bin:$PATH"' >> ~/.bashrc \
    && echo 'eval "$(pyenv init --path)"' >> ~/.bashrc \
    && echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc \
    && echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile \
    && echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile \
    && echo 'eval "$(pyenv init -)"' >> ~/.profile

WORKDIR ${PROJECT_DIR}

CMD [ "tail", "-f /dev/null" ]