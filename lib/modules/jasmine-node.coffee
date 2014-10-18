JasmineLocal = require './jasmine-local'

class JasmineNode extends JasmineLocal

  type: 'jasmine-node'

  extension: false

  _getJasminePath: ->
    "jasmine-node"

module.exports = JasmineNode
