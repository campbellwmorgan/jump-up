fs = require 'fs'
_ = require 'lodash'
watch = require 'node-watch'
sys = require 'sys'
exec = require('child_process').exec

defaultConfig = __dirname + '/../watchAreas'

notifyModules = require('./notify')

argv = require('optimist')
  .default('config', defaultConfig)
  .default('debug', false)
  .default('platform', 'gnome')
  .argv

# check whether platform exists
unless argv.platform of notifyModules
  console.error("Unknown platform #{argv.platform} ")
  process.exit()

writeError = (message) ->
  notifyModules[argv.platform] message, runTask

###
@param {string} command
@param {function} (stdout, stderr, writeError) ->
###
runTask = (command, alertCallback) ->
  child = exec command
  child.stderr.on 'data', (data) ->
    sys.print data
    writeError data

  child.stdout.on 'data', (data) ->
    sys.print data
    if alertCallback?
      alertCallback data, '', writeError


def =
  type: 'coffee'  # type of conversion : coffee, sass
  outputDir: false # if coffee goes in another dir
  dir: 'adminSubdomain/' # root of watch
  masterFile: 'admin.sass' # single file to convert
  recursive: true # look in subdirectories as well
  ignoreFiles: [] # any files to ignore



# load all of the modules into
# the module object
fileFilter = (file) ->
  return false unless file.match /\.(coffee|js)$/i
  return false if file.match /base\.coffee$/i
  true

modules = {}

unless argv._.length
  console.error "Usage: jumpup [options] <secion1> <section2>"
  process.exit()

unless fs.existsSync(argv.config)

  console.error "No Config File Found"

configPath = fs.realpathSync(argv.config)

sections = require(configPath)

# find each file in the modules
# directory and add to a set type
moduleDir = __dirname + '/modules'
fs.readdirSync(moduleDir)
  .filter(fileFilter)
  .forEach (file) ->
    Obj = require moduleDir + '/' + file
    ob = new Obj()
    modules[ob.type] = Obj
    if argv.debug
      console.log 'registered ' + ob.type


# begin the watch process
beginWatch = () ->
  return console.log 'please enter a watch area ' if process.argv.length < 3
  appRoot = process.argv[1].replace /devUtils.*$/, ''
  argv._.forEach (section) ->
    if section of sections
      console.log 'initialising watch for ' + section
      runWatch sections[section]
    else
      console.log 'unrecognised section: ' + section

# works out if a file is in
# the given directory
matchDir = (dir, filename) ->
  match = true
  splitDir = dir.split('/')
  splitDir.forEach (item, index) ->
    return if index is (splitDir.length - 1)
    match = false unless filename.split('/')[index] is item
    true

  match

runWatch = (sect) ->
  data = sect.parts
  appRoot = sect.root
  inProcess = false

  callback = (filename) ->
    return if inProcess
    inProcess = true
    data.forEach (item) ->
      # check if filename matches regex pattern
      if item.type of modules
        # instantiate the module
        Module = modules[item.type]
        module = new Module runTask,
        matchDir, appRoot, item

        module.start filename

    setTimeout ->
      inProcess = false
    , 3000

  # run bootstrap item
  data.forEach (item) ->

    # cycle through array
    # in directory
    if _.isArray item.dir
      item.dir.forEach (newDir) ->
       watch appRoot + newDir, callback
       if argv.debug
         console.log "starting watch for #{item.type} in",  appRoot + newDir
    else
      res = watch appRoot + item.dir, callback
      if argv.debug
        console.log "starting watch for #{item.type} in",  appRoot + item.dir

    if item.type of modules
      Module = modules[item.type]
      module = new Module runTask
      , matchDir, appRoot, item

      # execute any bootstrap functions
      # on module
      module.runBootstrap watch, callback

    else
      console.error "Type #{item.type} not registered"

    true
beginWatch()

