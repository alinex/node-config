import Debug from 'debug'
import os from 'os'
import path from 'path'
import fs from 'fs'

const debug = Debug('config:compiler')

// get possible configuration source folders
function configFolders(name) {
  const folder = []
  switch (os.platform()) {
  case 'win32':
    folder.push(path.join(os.homedir(), `.${name}`))
    break
  case 'darwin':
    folder.push(path.join(os.homedir(), `/Library/Preferences/${name}`))
    folder.push(`/Library/Application Support/${name}`)
    break
  default:
    folder.push(path.join(os.homedir(), `.${name}`))
    folder.push(`/etc/${name}`)
  }
  folder.push('config')
  return folder
}

class Compiler {

  constructor(setup = {}) {
    debug('new instance: %o', setup)
    this.configName = setup.configName || 'alinex'
    this.schemaPath = setup.schemaPath || `${__dirname}/config`
    this.configFolders = configFolders(this.configName)
  }

  // get list of schema definitions
  schema() {
    return new Promise((cb) => {
      // get files from
      fs.readdir(this.schemaPath, (err, files) => {
        if (err) {
          return cb(err)
        }
        files.forEach((file) => {
          console.log(file)
        })
        return cb()
      })
    })
  }

  // load configuration of schema
//  load(schema, path) {}

  // run validation and optimization over configuration
//  validate(schema, data) {}

  // store as javascript
//  write(schema, data) {}

}

export default Compiler
