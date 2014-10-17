Base = require './base'

class Coffee extends Base

  type: 'coffee'

  extension: /\.coffee$/

  run: (item, filename) =>
    return unless @match filename

    recursive = 'recursive' of item and
    item.recursive is true

    return if not recursive and
    filename.split('/').length > @workingDir.split('/').length

    outDir = if 'outputDir' of item
    then '-o ' + @appRoot + item.outputDir + ' '
    else ''

    @runTask 'coffee ' + outDir + '-c ' + filename
    console.log 'Compiling ' + filename

module.exports = Coffee
