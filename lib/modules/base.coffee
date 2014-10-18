class Base
  # extend this with the
  # method type
  type: 'base'

  debounceTime: 1


  # regex to match the extension
  extension: false # or /\.extension$/

  constructor: (runTask, @appRoot, @item) ->
    return unless runTask?

    @workingDir = @appRoot + @item.dir
    @runTimeouts = {}
    @_debounceTime = @debounceTime
    # allow override of debounceTime
    # (time in ms)
    if 'debounce' of @item
      @_debounceTime = @item.debounce

    @setup(runTask)

  setup: (runTask) =>
    @runTask = (command) =>
      if command of @runTimeouts
        clearTimeout @runTimeouts[command]
      @runTimeouts[command] = setTimeout =>
        runTask command, @alertFilter
      , @_debounceTime

  match: (filename) =>
    @matchDir @workingDir, filename

  ###
  Validates whether filepath
  is within src directory
  @return {boolean}
  ###
  matchDir: (src, filepath) ->
    match = true
    splitDir = src.split('/')
    splitDir.forEach (item, index) ->
      return if index is (splitDir.length - 1)
      match = false unless filepath.split('/')[index] is item
      true

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
  Interal function for
  running watch on altDir if it exists
  ###
  runBootstrap: (watch, callback) =>
    unless 'altDir' of @item and @item.altDir.length
      return @bootstrap watch, callback

    @item.altDir.forEach (altDir) =>
      console.log 'adding alt dir. watch for ' +
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
