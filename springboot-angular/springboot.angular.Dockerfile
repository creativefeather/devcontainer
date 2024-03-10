# syntax=docker/dockerfile:1

ARG BASE_IMAGE

### BASE ###
FROM --platform=${TARGETPLATFORM} ${BASE_IMAGE} AS development

LABEL maintainer="creativefeather <creativefeather@outlook.com>"
LABEL description="A nodejs development image with nvm."
LABEL version="1.0"
LABEL vendor=""
LABEL url=""
LABEL license="MIT"

ARG USER=dev

USER ${USER}
WORKDIR /app
ENV PATH="/home/dev/.nvm/versions/node/v20.11.1/bin:${PATH}"

# Install Angular CLI
RUN npm install -g @angular/cli

CMD [ "node --version" ]