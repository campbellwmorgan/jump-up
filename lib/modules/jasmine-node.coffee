JasmineLocal = require './jasmine-local'

class JasmineNode extends JasmineLocal

  type: 'jasmine-node'

  extension: false

  _getJasminePath: ->
    "jasmine-node"

  alertFilter: (stdout, stderr, writeError) ->
    if stdout.match /0 failures/g
      writeError stdout


module.exports = JasmineNode
