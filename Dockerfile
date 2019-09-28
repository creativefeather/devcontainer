FROM node:lts AS base

ARG APP_DIR=/home/node/svelte-app
ARG APP_FILES_SRC=app
ARG APP_FILES_DEST=/home/node/temp

WORKDIR ${APP_DIR}
COPY ${APP_FILES_SRC}/svelte-init /usr/local/bin/
COPY ${APP_FILES_SRC}/EXTRA_SETUP.md \
     ${APP_FILES_SRC}/docker-compose.yml \
     ${APP_FILES_SRC}/docker-compose.override.yml \
     ${APP_FILES_DEST}/

RUN apt-get update &&\
    #
    # Install npm packages
    npm install -g degit tslint typescript &&\
    #
    # Clean up
    apt-get autoremove -y &&\
    apt-get clean -y &&\
    rm -rf /var/lib/apt/lists/*

ENV APP_DIR ${APP_DIR}
ENV APP_FILES ${APP_FILES_DEST}

CMD [ "svelte-init" ]