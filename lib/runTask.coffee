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
      console.log data
      writeError data

    child.stdout.on 'data', (data) ->
      console.log data
      if alertCallback?
        alertCallback data, '', writeError


    # return the child
    # process
    child
