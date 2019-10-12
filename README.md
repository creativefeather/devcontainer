# Nodejs Development Container
## Global Packages (from base Dockerfile)
* yarn
* typscript
* @typescript-eslint/parser
* @typescript-eslint/eslint-plugin
* eslint
* lerna
* oclif

# Scripts

\* Make sure to modify the npm scripts: *__build__* _--tag \<value\>_ option & *__push__* image argument.

First build, then run/create a container to create an image out of (docker commit). After, push the image to docker hub.

## _[build]_

     $ npm run build

Builds a docker image from the **Dockerfile** in _.devcontainer_.

## _[push]_

     $ npm run push

Pushes built image to **Docker Hub**.

## _[git:file]_

     $ npm run git:file <path-spec>...

A script to grab another file in another branch--grab the _.devcontainer_ files.

## _[git:orphan]_

     $ npm run git:orphan <new-branch> [<start point>]

Create an orphaned branch for creating another _devcontainer_ image.