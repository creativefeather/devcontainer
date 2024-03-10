# syntax=docker/dockerfile:1

ARG BASE_IMAGE="debian:bullseye-20240211-slim"

### BASE ###
FROM --platform=${TARGETPLATFORM} ${BASE_IMAGE} AS java-21-bullseye

LABEL maintainer="creativefeather <creativefeather@outlook.com>"
LABEL description="Provides the base image for all development and production images."
LABEL version="1.0"
LABEL vendor=""
LABEL url=""
LABEL license="MIT"

ARG USER=dev

LABEL openjdk="https://jdk.java.net/"

# The JAVA_DOWNLOAD_URL is architecture-specific, PASS AS BUILD-ARG!
ARG JAVA_DOWNLOAD_URL
ARG MAVEN_DOWNLOAD_URL="https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz"

ENV JAVA_HOME=/opt/jdk \
    MAVEN_HOME=/opt/maven-3.9.6 \
    PATH=${JAVA_HOME}/bin:${MAVEN_HOME}/bin:$PATH

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