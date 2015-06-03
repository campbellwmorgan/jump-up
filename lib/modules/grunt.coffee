Base = require './base'
path = require 'path'

class Grunt extends Base

  type: 'grunt'

  run: (item, filename) =>
    return unless filename.match item.regex

    return if item.limitToDir? and
    not @matchDir(@appRoot + item.dir, filename)
    console.log 'running Grunt in directory'
    command = path.join(@workingDir, 'grunt')
    @runTask 'cd ' + @workingDir + ' ; grunt'

module.exports = Grunt
