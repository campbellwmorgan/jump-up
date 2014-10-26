Base = require './base'
_ = require 'lodash'

class Gulp extends Base

  type: 'gulp'

  run: (item, filename) =>
    # return unless regex match
    if item.regex
      return unless filname.match item.regex

    # ensure item within set directory
    if _.isArray item.dir
      match = _.reduce item.dir, (memo, dir) =>
        return memo if memo
        return true if @matchDir(@appRoot + dir, filename)
      , false
      return unless match
    else
      return unless @matchDir(@appRoot + dir, filename)

    section = if item.section then item.section else ''

    console.log 'running gulp in directory'

    command = "cd #{@appRoot} && " +
    "./node_modules/.bin/gulp #{section}"

    @runTask command



module.exports = Gulp
