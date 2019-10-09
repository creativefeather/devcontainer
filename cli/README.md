svelte-app
==========

Tool for initializing Svelte or Sapper projects

[![oclif](https://img.shields.io/badge/cli-oclif-brightgreen.svg)](https://oclif.io)
[![Version](https://img.shields.io/npm/v/svelte-app.svg)](https://npmjs.org/package/svelte-app)
[![Downloads/week](https://img.shields.io/npm/dw/svelte-app.svg)](https://npmjs.org/package/svelte-app)
[![License](https://img.shields.io/npm/l/svelte-app.svg)](https://github.com/creativefeather/svelte-app/blob/master/package.json)

<!-- toc -->
* [Usage](#usage)
* [Commands](#commands)
<!-- tocstop -->
# Usage
<!-- usage -->
```sh-session
$ npm install -g @creativefeather/svelte-app
$ svelte-app COMMAND
running command...
$ svelte-app (-v|--version|version)
@creativefeather/svelte-app/0.0.0 linux-x64 node-v10.16.3
$ svelte-app --help [COMMAND]
USAGE
  $ svelte-app COMMAND
...
```
<!-- usagestop -->
# Commands
<!-- commands -->
* [`svelte-app add [FILE]`](#svelte-app-add-file)
* [`svelte-app help [COMMAND]`](#svelte-app-help-command)
* [`svelte-app init [HELLO]`](#svelte-app-init-hello)

## `svelte-app add [FILE]`

describe the command here

```
USAGE
  $ svelte-app add [FILE]

OPTIONS
  -f, --force
  -h, --help       show CLI help
  -n, --name=name  name to print
```

_See code: [src/commands/add.ts](https://github.com/creativefeather/svelte-app/blob/v0.0.0/src/commands/add.ts)_

## `svelte-app help [COMMAND]`

display help for svelte-app

```
USAGE
  $ svelte-app help [COMMAND]

ARGUMENTS
  COMMAND  command to show help for

OPTIONS
  --all  see all commands in CLI
```

_See code: [@oclif/plugin-help](https://github.com/oclif/plugin-help/blob/v2.2.1/src/commands/help.ts)_

## `svelte-app init [HELLO]`

describe the command here

```
USAGE
  $ svelte-app init [HELLO]

ARGUMENTS
  HELLO  hello message

OPTIONS
  -f, --force
  -h, --help       show CLI help
  -n, --name=name  name to print
```

_See code: [src/commands/init.ts](https://github.com/creativefeather/svelte-app/blob/v0.0.0/src/commands/init.ts)_
<!-- commandsstop -->
