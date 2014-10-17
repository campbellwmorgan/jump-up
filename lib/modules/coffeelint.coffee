Base = require './base'
class CoffeeLint extends Base
  type: 'coffeelint'

  extension: /\.coffee$/

  run: (item, filename) =>
    return unless @match filename
    console.log 'running coffee linting'
    @runTask 'coffeelint ' + filename

  alertFilter: (stdout, stderr, writeError) ->
    if stdout.match /Lint/
      console.log 'error thrown'
      writeError stdout

module.exports = CoffeeLint
