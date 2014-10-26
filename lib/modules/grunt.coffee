Base = require './base'

class Grunt extends Base

  type: 'grunt'

  run: (item, filename) =>
    return unless filename.match item.regex

    return if item.limitToDir? and
    not @matchDir(@appRoot + item.dir, filename)
    console.log 'running Grunt in directory'
    @runTask 'cd ' + @workingDir + ' ; grunt'

module.exports = Grunt
