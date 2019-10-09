import {Command, flags} from '@oclif/command'
import {spawnSync} from 'child_process'
import fs from 'fs'
import inquirer, {Answers} from 'inquirer'
import path from 'path'

const prompt = inquirer.createPromptModule()



export default class Init extends Command {
  static description = 'Init new svelte or sapper app'
  static flags = {
    help: flags.help({char: 'h'})
  }

  async run() {
    return prompt([
      qBoilerplate,
      qBundler
    ]).then(answers => {
      //
    })
  }
}

const qBoilerplate = {
  type: 'list',
  name: 'boilerplate',
  message: 'What kind of project do you want to init?',
  choices: [
    {name: 'svelte'},
    {name: 'sapper'}
  ],
  default: 0
}

const qBundler = {
  type: 'list',
  name: 'bundler',
  message: '',
  choices: [
    {name: 'rollup'},
    {name: 'webpack'}
  ],
  default: 0,
  when: (answers: Answers) => answers.boilerplate === 'sapper'
}

/**
 * Returns 'true' if the cwd is empty
 */
const isCwdEmpty = (): boolean => {
  const files = fs.readdirSync(process.cwd())
  return files.length === 0
}

const _init = (fn: () => void) => {
  if (isCwdEmpty()) {
    fn()
    spawnSync('npm', ['install'])
  }
}

export const svelteInit = () => {
  _init(() => {
    spawnSync('npx', ['degit', 'sveltejs/template'])
    spawnSync('npm', ['install', '--save-dev', 'chokidar'])

    // Need to replace variables in docker-compose files
  })
}

export const sapperInit = (bundler: string) => {
  _init(() => {
    spawnSync('npx', ['degit', `sveltejs/sapper-template#${bundler}`, '.'])
  })
}
