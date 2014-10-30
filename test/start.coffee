jasmine = require 'minijasminenode2'
glob = require 'glob'

jasmine.executeSpecs
  specs: glob.sync(__dirname + "/lib/**/*_spec.coffee")
  showColors: true
  isVerbose: true
