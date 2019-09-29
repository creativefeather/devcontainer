#!/bin/bash

if [ $1 == 'svelte' ]
then
  docker run --rm -it -v $(pwd)/svelte-test:/home/node/app creativefeather/svelte
elif [ $1 == 'sapper' ]
then
  docker run --rm -it -v $(pwd)/sapper-test:/home/node/app creativefeather/sapper
else
  echo 'docker-run <svelte | sapper>'
fi