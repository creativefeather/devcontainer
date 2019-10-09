ARG APP_FILES_SRC=app

##################
### Base Image ###
##################
FROM node:lts AS base

ARG APP_FILES_SRC
ENV APP_DIR /home/node/app
ENV APP_FILES_DEST /home/node/temp

WORKDIR ${APP_DIR}

COPY ${APP_FILES_SRC}/EXTRA_SETUP.md \
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

####################
### Svelte Image ###
####################
FROM base AS svelte

ARG APP_FILES_SRC
COPY ${APP_FILES_SRC}/svelte-init \
     /usr/local/bin/
COPY ${APP_FILES_SRC}/docker-compose.svelte.yml \
     ${APP_FILES_SRC}/docker-compose.override.svelte.yml \
     ${APP_FILES_DEST}/

CMD [ "svelte-init" ]

####################
### Sapper Image ###
####################
FROM base as sapper

ARG APP_FILES_SRC
COPY ${APP_FILES_SRC}/sapper-init \
     /usr/local/bin/
COPY ${APP_FILES_SRC}/docker-compose.sapper.yml \
     ${APP_FILES_SRC}/docker-compose.override.sapper.yml \
     ${APP_FILES_DEST}/

ENTRYPOINT [ "sapper-init" ]
CMD [ "rollup" ]