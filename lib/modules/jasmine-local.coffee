Base = require './base'
path = require 'path'
fs = require 'fs'
_ = require 'lodash'

class JasmineLocal extends Base

  type: 'jasmine-local'

  # 4 second debounce
  debounceTime: 4000

  extension: /\.coffee$/

  run: (item, filename) =>
    return unless @match filename
    fileBase = path.basename filename
    nameOnly = fileBase.replace /\.[^\.]+$/, ''
    dir = path.dirname filename
    relativePath = path.relative(@appRoot, dir) + '/'

    testPrefix = if 'testPrefix' of item
    then item.testPrefix
    else 'test/'
    specFile = @appRoot + testPrefix + relativePath +
    @_toCamel(nameOnly) + '_spec.coffee'

    unless fs.existsSync(specFile)
      return console.log("No tests found for #{specFile}")

    console.log 'running local jasmine node'
    # add verbose flag
    verbose = if 'verbose' of item and item.verbose
    then ' --verbose'
    else ''
    # add coffee flag
    coffee = if 'coffee' of item and item.verbose
    then ' --coffee'
    else ''
    envs = @_makeEnvs item
    # try and find the spec file
    @runTask "#{envs}#{@appRoot}/node_modules/.bin/jasmine-node #{coffee} #{verbose} #{specFile}"

  _makeEnvs: (item) ->
    return '' unless 'env' of item
    _.reduce item.env, (memo, item, key) ->
      memo + "#{key}=#{item} "
    , ''

  _toCamel: (string) ->
    string.charAt(0).toLowerCase() + string.slice(1)

  alertFilter: (stdout, stderr, writeError) ->
    if stdout.match /uncaughtException/g or
    stderr.match /uncaughtException/g
      writeError stdout
    if stdout.match /\[Error/g
      writeError stdout
    if stdout.match /0 failures/g
      writeError stdout

module.exports = JasmineLocal
