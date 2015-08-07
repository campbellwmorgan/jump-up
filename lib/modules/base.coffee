_ = require 'lodash'
async = require 'async'
path = require 'path'
class Base
  # extend this with the
  # method type
  type: 'base'

  debounceTime: 1


  # regex to match the extension
  extension: false # or /\.extension$/

  constructor: (runTask, @appRoot, @item) ->
    return unless runTask?

    if _.isString @item.dir
      @workingDir = @appRoot + @item.dir

    else
      if _.isArray @item.dir
        @workingDir = _.map @item.dir, (dir) =>
          @appRoot + dir
      else
        @workingDir = @appRoot

    # list of active child processes
    # for this module
    @activeProcesses = {}

    @runTimeouts = {}
    @_debounceTime = @debounceTime
    # allow override of debounceTime
    # (time in ms)
    if 'debounce' of @item
      @_debounceTime = @item.debounce

    @setup(runTask)

  ###
  Instantiates run task function
  ###
  setup: (runTask) =>
    ###
    # @param {String} command
    # @param {String} current working directory (optional)
    ###
    @runTask = (command, cwd) =>
      if command of @runTimeouts
        clearTimeout @runTimeouts[command]
      @runTimeouts[command] = setTimeout =>
        child = runTask command, @alertFilter, cwd

        return unless child
        # add kill command for child
        # to list of
        # active processes
        pid = child.pid
        @activeProcesses[pid] =
          child: child
          pid: pid
          kill: (cb)->
            child.on 'exit', (code) ->
              cb(null, code)

            child.kill('SIGTERM')


        # when the child exists
        # remove it from the list
        # of active processes
        child.on 'exit', =>
          delete @activeProcesses[pid]

      , @_debounceTime

  ###
  Kills all childprocesses
  running for this instance

  @param {function} callback called when all killed
  ###
  killAll: (cb) =>
    totalProcesses = _.keys(@activeProcesses).length

    return cb() unless totalProcesses

    processes = _.values(@activeProcesses)

    async.each processes
    , (proc, callback) ->
      return callback() unless 'kill' of proc
      proc.kill callback
    , ->
      cb()

  ###
  Tests if a file is
  within the current working dir

  @return {Boolean}
  ###
  match: (filename) =>
    @matchDir @workingDir, filename

  ###
  Validates whether filepath
  is within src directory
  @return {boolean}
  ###
  matchDir: (src, filepath) =>

    # match a series of directories
    if _.isArray src
      return _.reduce src, (memo, thisSrc) =>
        # if already matched, return true
        return memo if memo

        return true if @matchDir thisSrc, filepath

        false
      , false

    match = true
    relative = path.relative(src, filepath)
    # if relative path starts with contains ".."
    # then outside directory root
    if relative.match /^\.\./
      return false

    match

  start: (filename) =>
    return if @extension and not filename.match @extension
    @run @item, filename

  # any other items
  # to execute before main watcher
  # @param {function} watcher function
  # @param {function} ready callback
  bootstrap: (watch, callback) =>

  ###
  Main Run function to be overriden
  in each module
  @param {object} config item
  @param {string} filePath
  ###
  run: (item, filename) =>

  ###
  Interal function for
  running watch on altDir if it exists
  ###
  runBootstrap: (watch, callback) =>
    unless 'altDir' of @item and @item.altDir.length
      return @bootstrap watch, callback

    @item.altDir.forEach (altDir) =>
      @appRoot + altDir
      watch @appRoot + altDir, callback
      true

    @bootstrap watch, callback

  ###
  # filters cli output
  # @param {Buffer} stdout
  # @param {Buffer} stderr
  # @param {function} writes error gnome
  ###
  alertFilter: (stdout, stderr, writeError) ->


module.exports = Base
