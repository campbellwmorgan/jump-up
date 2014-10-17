Base = require './base'

class Karma extends Base

  type: 'karma'

  run: (item, filename) =>

  bootstrap: =>
    @runTask 'gnome-terminal -e "karma start ' +
    @appRoot + @item.config + '"'

module.exports = Karma
