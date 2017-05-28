import should from 'should'
import Debug from 'debug'

import Compiler from '../../src/compiler'

const debug = Debug('test')

describe('environment', () => {
  it('have default folders', () => {
    const compiler = new Compiler
    debug(compiler)
    compiler.configName.should.be.equal('alinex')
    compiler.configFolders.should.be.Array()
    compiler.configFolders.length.should.be.aboveOrEqual(2)
    compiler.configFolders[0].should.containEql('alinex')
  })
  it('should allow specific folders', () => {
    const compiler = new Compiler({configName: 'myapp'})
    debug(compiler)
    compiler.configName.should.be.equal('myapp')
    compiler.configFolders.should.be.Array()
    compiler.configFolders.length.should.be.aboveOrEqual(2)
    compiler.configFolders[0].should.containEql('myapp')
  })
})

it('async await', () => {
  function timeout(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  const wait = async () => {
    console.log(await timeout(5))
    return "done"
  }
  wait()
})

describe('compiling', () => {
  it('have default folders', (cb) => {
    const compiler = new Compiler({schemaPath: 'test/data/config'})
    compiler.schema()
    .then(cb)
  })
})
