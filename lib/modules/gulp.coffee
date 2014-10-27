Base = require './base'
_ = require 'lodash'

class Gulp extends Base

  type: 'gulp'

  run: (item, filename) =>
    # return unless regex match
    if item.regex
      return unless filname.match item.regex

    return unless @match filename

    section = if item.section then item.section else ''

    console.log 'running gulp in directory'

    command = "cd #{@appRoot} && " +
    "./node_modules/.bin/gulp #{section}"

    @runTask command



module.exports = Gulp
