# syntax=docker/dockerfile:1

### BASE ###
FROM --platform=${TARGETPLATFORM} debian:bullseye-20240211-slim AS base

LABEL maintainer="creativefeather <creativefeather@outlook.com>"

ARG TARGETPLATFORM
ARG USER=dev
ARG UID=1000
ARG GID=1000

LABEL openjdk="https://jdk.java.net/"
# The JAVA_DOWNLOAD_URL is architecture-specific, PASS AS BUILD-ARG!
ARG JAVA_DOWNLOAD_URL
ARG MAVEN_DOWNLOAD_URL="https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz"

ENV JAVA_HOME=/opt/jdk \
    MAVEN_HOME=/opt/maven-3.9.6 \
    PATH=${JAVA_HOME}/bin:${MAVEN_HOME}/bin:$PATH

# create a non-root user, app directory and install dependencies
RUN groupadd --gid "${GID}" ${USER} \
    && useradd --create-home --no-log-init -u "${UID}" -g "${GID}" -s "/bin/bash" "${USER}" \
    && mkdir -p /app \
    && chown -R ${USER}:${GID} /app \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       curl \
       ca-certificates \
       # Clean up
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Install JDK using Jabba. Jabba is a cross-platform Java Version Manager.
RUN curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | \
    JABBA_COMMAND="install 21.0.2-custom=tgz+${JAVA_DOWNLOAD_URL} -o $JAVA_HOME" bash

# Install Maven
RUN mkdir ${MAVEN_HOME} \
    && curl -sSL ${MAVEN_DOWNLOAD_URL} | tar -xzv -C ${MAVEN_HOME} --strip-components=1

USER ${USER}
ENV PATH=${JAVA_HOME}/bin:${MAVEN_HOME}/bin:$PATH

WORKDIR /app

CMD ["java", "--version", "&&", "mvn", "--version"]