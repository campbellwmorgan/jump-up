Base = require './base'
_ = require 'lodash'
path = require 'path'

class Gulp extends Base

  type: 'gulp'

  run: (item, filename) =>
    # return unless regex match
    if item.regex
      return unless filename.match item.regex

    return unless @match filename

    @runGulp()


  runGulp: () =>
    section = if @item.section
    then @item.section else ''

    console.log 'running gulp in directory'

    gulpPath = if @item.gulpDir
    then @appRoot + @item.gulpDir
    else @appRoot


    command = path.join(
      gulpPath,
      'node_modules',
      '.bin',
      "gulp #{section}"
    )

    @runTask command, @appRoot

  bootstrap: =>
    # run gulp if user has requested
    # execute on start
    @runGulp() if @item.executeOnStart



module.exports = Gulp
