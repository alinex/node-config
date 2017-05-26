import Debug from 'debug'
import os from 'os'
import path from 'path'

const debug = Debug('config:compiler')

const SYS_FOLDER = 'alinex'

// get possible configuration source folders
const folder = []
switch (os.platform()) {
case 'linux':
  folder.push(`/etc/${SYS_FOLDER}`)
  break
default:
}
folder.push(path.join(os.homedir(), `.${SYS_FOLDER}`))
folder.push('local')

export default debug
export { folder }
