_ = require 'lodash'
###
Begins the watch process
for each section described
in the user's config file
@param {object} available modules
@param {function} node watch
@param {function} runtask - runner
###
module.exports = (modules, watch, runTask, argv, log)->
  moduleCache = {}
  ###
  Executes with for specific section
  ###
  main = (sect) ->
    # individual "topics" inside
    # a group
    parts = sect.parts
    unless parts
      parts = []

    appRoot = if sect.root
    then sect.root
    else process.cwd() + '/'

    # timeout for preventing
    # item from being run too many times
    inProcess = false

    getModule = (item) ->
      return false unless item.type of modules
      if item.type of moduleCache
        return moduleCache[item.type]
      Module = modules[item.type]
      moduleCache[item.type] = new Module runTask
      , appRoot, item

      moduleCache[item.type]

    ###
    Callback called on each item
    ###
    callback = (filename) ->
      return if inProcess
      inProcess = true
      parts.forEach (item) ->

        # instantiate module
        module = getModule item
        if module
          module.start filename
      setTimeout ->
        inProcess = false
      , 3000

    # run bootstrap item
    parts.forEach (item) ->

      # cycle through array
      # in directory
      if _.isArray item.dir
        item.dir.forEach (newDir) ->
          watch appRoot + newDir, callback
          if argv.debug
            log.log "starting watch for #{item.type} in",  appRoot + newDir
      else
        res = watch appRoot + item.dir, callback
        if argv.debug
          log.log "starting watch for #{item.type} in",  appRoot + item.dir

      module = getModule item
      if module
        # execute any bootstrap functions
        # on module
        module.runBootstrap watch, callback

      else
        log.error "Type #{item.type} not registered"

      true

