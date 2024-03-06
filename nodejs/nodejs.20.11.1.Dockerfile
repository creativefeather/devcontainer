# syntax=docker/dockerfile:1

### BASE ###
FROM --platform=${TARGETPLATFORM} base:bullseye-20240211-slim AS development

LABEL maintainer="creativefeather <creativefeather@outlook.com>"
LABEL description="A nodejs development image with nvm."
LABEL version="1.0"
LABEL vendor=""
LABEL url=""
LABEL license="MIT"

LABEL nodejs="https://nodejs.org/"
LABEL nvm="https://github.com/nvm-sh/nvm"

ARG TARGETPLATFORM
ARG USER=dev
ARG UID=1000
ARG GID=1000

# create a non-root user, app directory and install dependencies
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    curl \
    git \
    # Clean up
 && rm -rf /var/lib/apt/lists/* \
 && apt-get clean

# The nvm install scipt installs to the user's home directory, so let's switch users now.
USER ${USER}

# Install NVM
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
RUN export NVM_DIR="$HOME/.nvm" \
   && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
   && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" \
   && nvm install 20.11.1

WORKDIR /app

CMD ["node", "--version", "&&", "npm", "--version"]