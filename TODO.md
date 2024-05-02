# TODOS

[ ] The build script for Java contains incomplete code for building a manifest

[ ] Build scripts need a $Name and $Tag parameter to override when needed

[ ] \nodejs\nodejs.20.11.1.Dockerfile, The ENV should not be hard coded for nvm.

# Compared with Docker Compose

_**Docker compose yaml**_ files look very much like a declarative 'docker run'
command. In fact, 'docker run' commands quite naturally map into services of a
docker-compose.yml file. If you look on DockerHub, you often find documentation
showing the 'docker run' commands--these are a great place to start when making
a docker-compose.yml file. Another project, 'Dockge', will actually convert
'docker run' commands into the appropriate compose names and values. Of course,
docker compose can also run a 'docker buildx build' if a 'build' is declared. It
also, encompasses making docker networks and docker volumes, and perhaps other
docker commands.

_**BuildHelpers**_ is a way for me to fill the gaps that multistage builds have
by chaining together various builds using the chain to supply the base image for
the next in the sequence. I very much see the similarities between Docker
compose and my BuildHelpers ...

- How can I make the declarative part of BuildHelpers more like a
  docker-compose.yml file?
- Is there a way to extend docker-compose.yml to include what I'm doing?
- Are there features about docker-compose.yml I'm unaware?
- Both extend docker-compose.yml in the docker-compose.yml and/or as an external
  buildspec.yml?
