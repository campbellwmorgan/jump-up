Base = require './base'
_ = require 'lodash'
class Sass extends Base
  type: 'sass'

  extension: /\.sass$/

  run: (item, filename) =>
    return unless @match filename

    loadPath = @_loadPath item

    style = if 'style' of item
    then '--style item.style'
    else ''
    if 'singleFile' of item and item.singleFile.length
      _.each item.singleFile, (sassFile) =>
        @runTask "sass #{style} #{loadPath} " + @workingDir + sassFile.input +
          ' ' + @workingDir + sassFile.output
        console.log 'Change in ' + filename
        console.log 'Compiling ' + sassFile.input
    else
      @runTask "sass #{style} #{loadPath} " + filename + ' ' +
        filename.replace /\.sass$/, '.css'
      console.log 'Compiling ' + filename

  _loadPath: (item) ->
    return loadPath unless 'loadPath' of item
    unless _.isArray item.loadPath
      item.loadPath = [item.loadPath]

    loadPath = _.reduce item.loadPath, (memo, path) =>
      isAbsolute = path.match /^\//
      fullPath = if isAbsolute then path
      else @workingDir + path
      memo+= " --load-path #{fullPath}"
      memo
    , ''
module.exports = Sass
