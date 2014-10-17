Base = require './base'

class CleanCss extends Base

  type: 'cleancss'

  extension: /\.(css)|(sass)$/

  run: (item, filename) =>
    return unless @match filename
    console.log 'running cleancss in directory'
    item.files.forEach (cssFile) =>
      inputFile = @workingDir + cssFile.input
      outputFile = @workingDir + cssFile.output
      console.log 'compiling ' + inputFile + ' to ' + outputFile
      @runTask 'cleancss -o ' + outputFile + ' ' + inputFile


module.exports = CleanCss
