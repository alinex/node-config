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

describe('compiling', () => {
  it('have default folders', async () => {
    const compiler = new Compiler({schemaPath: 'test/data/config'})
    const files = await compiler.schema()
    console.log(files)
  })
})
