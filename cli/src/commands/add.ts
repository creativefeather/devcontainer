import {Command, flags} from '@oclif/command'

export default class Add extends Command {
  static description = 'Add files to the project from a template'

  async run() {
    //const {args, flags} = this.parse(Add)
  }
}

const qTemplate = {
  type: 'list',
  name: 'template',
  choices: [
    'vs-devcontainer'
  ]
}
