fs = require 'fs'
module.exports = (argv, moduleDir) ->
  # find each file in the modules
  # directory and add to a set type
  moduleDir = __dirname + '/modules' unless moduleDir?

  modules = {}

  fileFilter = (file) ->
    return false unless file.match /\.(coffee|js)$/i
    return false if file.match /base\.coffee$/i
    true

  fs.readdirSync(moduleDir)
    .filter(fileFilter)
    .forEach (file) ->
      Obj = require moduleDir + '/' + file
      ob = new Obj()
      modules[ob.type] = Obj
      if argv.debug
        console.log 'registered ' + ob.type

  modules

