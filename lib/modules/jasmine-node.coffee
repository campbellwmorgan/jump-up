Base = require './base'

class JasmineNode extends Base

  type: 'jasmine-node'

  extension: false

  run: (item, filename) =>
    return unless @match filename
    console.log 'running jasmine node'
    @runTask "jasmine-node --coffee #{@appRoot}#{item.specDir}"

  alertFilter: (stdout, stderr, writeError) ->
    if stdout.match /0 failures/g
      writeError stdout


module.exports = JasmineNode
