Base = require './base'

class Custom extends Base

  debounce: 1000

  type: 'custom'

  ###
  Run a custom command
  each time the directory changes
  ###
  run: (item, filename) =>
    return unless @match filename
    return unless 'change' of item

    # kill each process
    # and runTask when processes
    # have exited
    if item.killExisting
      @killAll (err, res) =>
        if err
          console.error 'Error killing task', err
        else
          console.log 'Killed task', item.description

        setTimeout =>
          @runTask item.change
        , 500
    else
      @runTask item.change

  ###
  Run Once when loading
  - good for running a server
  ###
  bootstrap: =>
    return unless 'bootstrap' of @item

    @runTask @item.bootstrap

module.exports = Custom
