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
    mainMatch = @match filename
    testDirMatch = @matchDir @appRoot + item.testDir
    , filename

    return if not mainMatch and not testDirMatch

    console.log 'running local jasmine node'

    envs = @_makeEnvs item
    flags = @_getFlags item
    specFile = @_getTarget item, filename
    jasminePath = @_getJasminePath()
    unless specFile
      return console.error("Spec File not found for #{filename}")
    # try and find the spec file
    @runTask "#{envs}#{jasminePath} #{flags} #{specFile}"

  _getJasminePath: =>
    "#{@appRoot}/node_modules/.bin/jasmine-node"

  ###
  Either returns the test
  directory or finds a specific
  file if the test directory
  mirrors main directory hierarchy
  eg:
    original file is controllers/MyController.coffee
    test file is test/controllers/myController_spec.coffee

  @return {string}
  ###
  _getTarget: (item, filename) =>
    # return directory if whole directory
    # is being tested
    return item.testDir unless item.perFile

    testPath = @_getTestDirectory item, filename

    nameOnly = @_getBasename filename

    ext = @_getExtension item

    # try to find the spec file as written
    noCaseChange = testPath + nameOnly + '_spec' + ext
    if fs.existsSync(noCaseChange)
      return noCaseChange

    camelName = testPath + @_toCamel(nameOnly) + ext
    if fs.existsSync(camelName)
      return camelName

    lowercase = testPath + nameOnly.toLowerCase() + ext
    if fs.existsSync(lowercase)
      return lowercase

    return false

  ###
  Gets the basename (excluding _spec)
  of the filename
  ###
  _getBasename: (filename) ->
    fileBase = path.basename filename
    nameOnly = fileBase
      .replace(/\.[^\.]+$/, '')
      .replace(/\_spec/, '')

  ###
  Gets the absolute path of the test directory
  @return {string}
  ###
  _getTestDirectory: (item, filename) =>
    dir = path.dirname filename

    relativePath = path.relative(@appRoot, dir) + '/'

    testDir = if 'testDir' of item
    then item.testDir
    else 'test/'
    # if the file is in the test directory
    # then just test the relative path
    if relativePath.indexOf(testDir) is 0
      testDir= ''

    testPath = @appRoot + testDir + relativePath

  _getExtension: (item) ->
    if item.coffee? and item.coffee
    then '.coffee'
    else '.js'

  _getFlags: (item) ->
    # add verbose flag
    verbose = if 'verbose' of item and item.verbose
    then ' --verbose'
    else ''
    # add coffee flag
    coffee = if 'coffee' of item and item.verbose
    then ' --coffee'
    else ''

    captureExceptions = if 'captureExceptions' of item and item.captureExceptions
    then '--captureExceptions'
    else ''

    coffee + ' ' + verbose


  _makeEnvs: (item) ->
    return '' unless 'env' of item
    _.reduce item.env, (memo, item, key) ->
      memo + "#{key}=#{item} "
    , ''

  _toCamel: (string) ->
    string.charAt(0).toLowerCase() + string.slice(1)

  ###
  Filter for command line errors
  ###
  alertFilter: (stdout, stderr, writeError) ->
    if stdout.match /uncaughtException/g or
    stderr.match /uncaughtException/g
      writeError stdout
    if stdout.match /\[Error/g
      writeError stdout
    matches = stdout.match /\d+ failures/gi
    if matches and
    not (matches[0] is "0 Failures" or
      matches[0] is "0 failures"
    )

      writeError stdout

  ###
  Execute watch on test dir too
  ###
  bootstrap: (watch, callback) =>
    watch @appRoot + @item.testDir, callback


module.exports = JasmineLocal
