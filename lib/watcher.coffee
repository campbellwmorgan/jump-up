fs = require 'fs'
_ = require 'lodash'
watch = require 'node-watch'
moduleLoader = require './moduleLoader'
watchRunner = require './watchRunner'
RunTask = require './runTask'

defaultConfig = __dirname + '/../watchAreas'

notifyModules = require('./notify')

argv = require('optimist')
  .default('config', defaultConfig)
  .default('debug', false)
  .default('platform', 'node')
  .argv

module.exports = (overrides = {}) ->
  log = if overrides.log?
  then overrides.log
  else console


  # check whether platform exists
  unless argv.platform of notifyModules
    log.error("Unknown platform #{argv.platform} ")
    process.exit()

  if overrides.watch?
    watch = overrides.watch

  if overrides.argv?
    argv = overrides.argv

  ###
  Main Function that notifies
  user - see ./lib/notify.coffee
  @param {string} message
  ###
  writeError = (message) ->
    notifyModules[argv.platform] message

  # override for testing
  if overrides.writeError
    writeError = overrides.writeError

  runTask = RunTask writeError

  if overrides.runTask?
    runTask = overrides.runTask


  # load all of the modules into
  modules = moduleLoader argv
  if overrides.modules
    modules = overrides.modules

  unless argv._.length
    log.error "Usage: jumpup [options] <secion1> <section2>"
    process.exit()

  unless overrides.config?
    unless fs.existsSync(argv.config)

      log.error "No Config File Found"
      process.exit()

    configPath = fs.realpathSync(argv.config)

    sections = require(configPath)
  else
    sections = overrides.config

  runWatch = watchRunner modules, watch, runTask, argv, log

  # begin the watch process
  beginWatch = () ->
    return log.log 'please enter a watch area ' if process.argv.length < 3
    appRoot = process.argv[1].replace /devUtils.*$/, ''
    argv._.forEach (section) ->
      if section of sections
        log.log 'initialising watch for ' + section
        # begin the watch process
        runWatch sections[section]
      else
        log.log 'unrecognised section: ' + section


  beginWatch()

