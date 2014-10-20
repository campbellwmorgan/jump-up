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
  ###
  Executes with for specific section
  ###
  main = (sect) ->
    # individual "topics" inside
    # a group
    parts = sect.parts
    appRoot = sect.root
    # timeout for preventing
    # item from being run too many times
    inProcess = false

    getModule = (item) ->
      return false unless item.type of modules
      Module = modules[item.type]
      module = new Module runTask
      , appRoot, item


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

