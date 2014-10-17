Base = require './base'

class PHPUnit extends Base

  type: 'phpunit'

  extension: /\.php$/

  run: (item, filename) =>
    mainMatch = @match filename
    testMatch = @matchDir @appRoot + item.test + '/', filename
    return if (!mainMatch && !testMatch)

    if 'oneFile' of item
      itemMatch = new RegExp(item.oneFile.replace(/\./,'\\.'))
      return unless filename.match itemMatch
    console.log 'running phpunit'
    @runTask 'phpunit' + @appRoot + item.test

  bootstrap: (watch, callback) =>
    # run another watch on the unit testing folder
    watch @appRoot + @item.test + '/', callback

  alertFilter: (stdout, stderr, writeError) ->
    if stdout.match /FAILURE/g
      writeError stdout

module.exports = PHPUnit
