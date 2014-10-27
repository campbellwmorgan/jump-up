sys = require 'sys'
exec = require('child_process').exec
###
Runs a command line command
###
module.exports = (writeError) ->
  ###
  @param {string} command
  @param {function} (stdout, stderr, writeError) ->
  @return {ChildProcess}
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


    # return the child
    # process
    child
