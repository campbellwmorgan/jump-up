Base = require './base'
_ = require 'lodash'


class Protractor extends Base

  type: 'protractor'

  timeouts: {}# dictionary of timeouts for protractor jobs

  startManager: =>
    return if @managerStarted
    @managerStarted = true
    console.log 'starting manager'
    @runTask 'webdriver-manager start'

  run: (item, filename) =>
    return unless @match filename
    console.log 'starting protractor timer'
    if filename of @timeouts
      clearTimeout @timeouts[filename]

    @timeouts[filename] = setTimeout =>
      console.log 'running protractor'
      @runTask 'protractor ' + @appRoot + item.config
    , item.delay

  bootstrap: =>
    @startManager()


module.exports = Protractor
