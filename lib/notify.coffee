###
List of possible services
###
module.exports =
  ###
  Executes the Gnome notify-send command
  ###
  gnome: (message, run) ->

    notifyText = 'notify-send --expire-time=5000 --hint=int:transient:1 "Watch Error" "' + message + '"'

    run notifyText

  ###
  Depends on growlnotify
  ###
  osx: (message, run) ->
    notifyText = "growlnotify -t 'Watch Error' #{message}"
    run notifyText

