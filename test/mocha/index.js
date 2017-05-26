import should from 'should'
import Debug from 'debug'

import * as compiler from '../../src/compiler'

const debug = Debug('test')

// run the tests
describe('environment', () => {

  it('find config folders', () => {
    debug({folder: compiler.folder})
    compiler.folder.should.be.Array()
    compiler.folder.length.should.be.equal(3)
    compiler.folder[0].should.containEql('/etc/')
  })

})
