# syntax=docker/dockerfile:1

### BASE ###
FROM --platform=${TARGETPLATFORM} debian:bullseye-20240211-slim AS base

LABEL maintainer="creativefeather <creativefeather@outlook.com>"
LABEL description="Provides the base image for all development and production images."
LABEL version="1.0"
LABEL vendor=""
LABEL url=""
LABEL license="MIT"

ARG TARGETPLATFORM
ARG USER=dev
ARG UID=1000
ARG GID=1000

# create a non-root user, app directory and install dependencies
RUN groupadd --gid "${GID}" ${USER} \
 && useradd --create-home --no-log-init -u "${UID}" -g "${GID}" -s "/bin/bash" "${USER}" \
 && mkdir -p /app \
 && chown -R ${USER}:${GID} /app \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates \
 # Clean up
 && rm -rf /var/lib/apt/lists/* \
 && apt-get clean