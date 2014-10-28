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
  main = (sect, sectName, count) ->
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

    getModule = (item, indx) ->
      return false unless item.type of modules
      hashKey = item.type + sectName + indx
      # check key exists in cache
      # then return it
      if hashKey of moduleCache
        return moduleCache[hashKey]

      # otherwise create new instance
      Module = modules[item.type]
      moduleCache[hashKey] = new Module runTask
      , appRoot, item

      moduleCache[hashKey]

    ###
    Callback called on each item
    ###
    callback = (indx) ->
      (filename) ->
        return if inProcess
        inProcess = true
        parts.forEach (item) ->

          # instantiate module
          module = getModule item, indx
          if module
            module.start filename
        setTimeout ->
          inProcess = false
        , 3000

    # run bootstrap item
    parts.forEach (item, indx) ->

      # cycle through array
      # in directory
      if _.isArray item.dir
        item.dir.forEach (newDir) ->
          watch appRoot + newDir, callback(indx)
          if argv.debug
            log.log "starting watch for #{item.type} in",  appRoot + newDir
      else
        res = watch appRoot + item.dir, callback(indx)
        if argv.debug
          log.log "starting watch for #{item.type} in",  appRoot + item.dir

      module = getModule item, indx
      if module
        # execute any bootstrap functions
        # on module
        module.runBootstrap watch, callback(indx)

      else
        log.error "Type #{item.type} not registered"

      true

