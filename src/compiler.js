import Debug from 'debug'
import os from 'os'
import path from 'path'

const debug = Debug('config:compiler')

// get possible configuration source folders
function configFolders(name) {
  const folder = []
  switch (os.platform()) {
  case 'linux':
    folder.push(`/etc/${name}`)
    break
  default:
    break
  }
  folder.push(path.join(os.homedir(), `.${name}`))
  folder.push('local')
  return folder
}

// class
class Compiler {

  constructor(setup = {}) {
    this.configName = setup.configName || 'alinex'
    this.schemaPath = setup.schemaPath || 'dist/config'
    this.configFolders = configFolders(this.configName)
    debug('new instance:', this)
  }

//  schema() {}

//  find(schema) {}

//  load(schema, path) {}

//  validate(schema, data) {}

//  write(schema, data) {}

}

export default Compiler
