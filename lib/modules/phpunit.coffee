Base = require './base'

class PHPUnit extends Base

  type: 'phpunit'

  extension: /\.php$/

  run: (item, filename) =>
    mainMatch = @match filename
    testRoot = @appRoot + item.test + '/'
    # remove any double slashes
    testRoot = testRoot.replace /\/\//, '/'
    testMatch = @matchDir testRoot, filename
    return false if (!mainMatch && !testMatch)

    if 'oneFile' of item
      itemMatch = new RegExp(item.oneFile.replace(/\./,'\\.'))
      return unless filename.match itemMatch
    @runTask 'phpunit ' + testRoot

  bootstrap: (watch, callback) =>
    # run another watch on the unit testing folder
    watch @appRoot + @item.test , callback

  alertFilter: (stdout, stderr, writeError) ->
    if stdout.match /FAILURE/g
      writeError stdout

module.exports = PHPUnit
