###
List of possible services
- now defaults to node-notifier for
  cross platform notifications
###
notifier = require('node-notifier')

module.exports =
  ###
  Executes Notification using node-notifier
  ###
  node: (message) ->
    notifier.notify
      title: 'JumpUp: Watch Error'
      sound: false
      message: message
      wait: false
      time: 5000
      hint:'int:transient:1'
    , (err, resp) ->
      console.error(err) if err

  ###
  Executes the Gnome notify-send command
  ###
  gnome: (message) ->

    notifyText = 'notify-send ' +
    '--expire-time=5000 ' +
    '--hint=int:transient:1 ' +
    '"Watch Error" "' + message + '"'
