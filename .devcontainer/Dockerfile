#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

FROM node:lts

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# The node image comes with a base non-root 'node' user which this Dockerfile
# gives sudo access. However, for Linux, this user's GID/UID must match your local
# user UID/GID to avoid permission issues with bind mounts. Update USER_UID / USER_GID 
# if yours is not 1000. See https://aka.ms/vscode-remote/containers/non-root-user.
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Configure apt and install packages
RUN apt-get update \
  && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \ 
  #
  # Verify git and needed tools are installed
  && apt-get -y install git iproute2 procps \
  #
  # Remove outdated yarn from /opt and install via package 
  # so it can be easily updated via apt-get upgrade yarn
  && rm -rf /opt/yarn-* \
  && rm -f /usr/local/bin/yarn \
  && rm -f /usr/local/bin/yarnpkg \
  && apt-get install -y curl apt-transport-https lsb-release \
  && curl -sS https://dl.yarnpkg.com/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/pubkey.gpg | apt-key add - 2>/dev/null \
  && echo "deb https://dl.yarnpkg.com/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get -y install --no-install-recommends yarn \
  #
  # [Optional] Update a non-root user to match UID/GID - see https://aka.ms/vscode-remote/containers/non-root-user.
  && if [ "$USER_GID" != "1000" ]; then groupmod node --gid $USER_GID; fi \
  && if [ "$USER_UID" != "1000" ]; then usermod --uid $USER_UID node; fi \
  # [Optional] Add add sudo support for non-root user
  && apt-get install -y sudo \
  && echo node ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/node \
  && chmod 0440 /etc/sudoers.d/node
# Install tslint and typescript globally
RUN npm install -g \
  eslint \
  @typescript-eslint/parser \
  @typescript-eslint/eslint-plugin \
  typescript \
  lerna \
  oclif
#
# Install vscode extensions
# RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg \
#   && install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/ \
#   && sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' \
#   && apt-get install apt-transport-https \
#   && apt-get update \
#   && apt-get -y install code
# RUN code --install-extension --user-data-dir /home/node "dbaeumer.vscode-eslint" \
#   && code --install-extension --user-data-dir /home/node "rbbit.typescript-hero" \
#   && code --install-extension --user-data-dir /home/node "gregorbiswanger.json2ts" \
#   && code --install-extension --user-data-dir /home/node "stringham.move-ts" \
#   && code --install-extension --user-data-dir /home/node "pmneo.tsimporter" \
#   && code --install-extension --user-data-dir /home/node "esbenp.prettier-vscode" \
#   && code --install-extension --user-data-dir /home/node "eg2.vscode-npm-script" \
#   && code --install-extension --user-data-dir /home/node "jasonnutter.search-node-modules" \
#   && code --install-extension --user-data-dir /home/node "christian-kohler.npm-intellisense" \
#   && code --install-extension --user-data-dir /home/node "christian-kohler.path-intellisense" \
#   && code --install-extension --user-data-dir /home/node "trabpukcip.vscode-npm-scripts"
#
# Clean up
RUN apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=
