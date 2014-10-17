Base = require './base'

class Php extends Base

  type: 'php'

  extension: /\.php$/

  run: (item, filename) =>
    return unless @match filename
    console.log 'running php linting'
    @runTask 'php -l ' + filename

module.exports = Php
