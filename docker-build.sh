#!/bin/bash

if [ $1 == 'svelte' ]
then
  docker build --target svelte -t creativefeather/svelte .
elif [ $1 == 'sapper' ]
then
  docker build --target sapper -t creativefeather/sapper .
else
  echo 'docker-build <svelte | sapper>'
fi