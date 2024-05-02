ARG BASE_IMAGE

FROM --platform=${TARGETPLATFORM} nodejs:20.11.1 as angular

LABEL maintainer="creativefeather <creativefeather@outlook.com>" \
      description="A nodejs development image with nvm." \
      version="1.0" \
      vendor="" \
      url="" \
      license="MIT"

ARG ANGULAR_VERSION=17.2.3
ARG APP_NAME=my_app
ARG GIT_USER_EMAIL=creativefeather@outlook.com
ARG GIT_USER_NAME=creativefeather
ARG ROUTING=true
ARG STYLE=css
ARG USER=dev

EXPOSE 4200
ENV PATH="/home/dev/.nvm/versions/node/v20.11.1/bin:${PATH}"
USER ${USER}
WORKDIR /app

# Install Angular CLI
RUN npm install -g @angular/cli@${ANGULAR_VERSION} \
 && git config --global user.email "${GIT_USER_EMAIL}" \
 && git config --global user.name "${GIT_USER_NAME}" \
 && npx ng config -g cli.analytics false

COPY home/startup.sh /home/dev/startup.sh

CMD ["sh", "-c", "~/startup.sh"]