# svelte-docker

## description
My project for building images (linux) ready to develop svelte and sapper code.  These images are on Docker Hub as 'creativefeather/svelte' and 'creativefeather/sapper'


### [creativefeather/svelte]
1) Initialize in to volume:

     > docker run --rm -it v "$(pwd)":/home/node/app creativefeather/svelte

2) EXTRA_SETUP.md

3) Then begin development:

     > docker-compose up

### [creativefeather/sapper]
(Not functional until polling is available in the sapper project itself)

# Development Notes
## Docker Dev

(TODO: Docker-in-Docker)

## CLI Script Dev
### Bash

     $ docker run --rm -it -v "$PWD":/usr/local/src -w /usr/local/src node:latest bash

### PowerShell

     $ docker run --rm -it -v "$(get-location):/usr/local/src" -w /usr/local/src node:latest bash