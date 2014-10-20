Base = require './base'

class NPMTest extends Base

  type: 'npm-test'

  # debounce by 5 seconds
  debounceTime: 5000


  run: (item, filename) =>
    return unless @match filename

    # run regex match
    if 'regex' of item and item.regex
      return unless filename.match item.regex

    console.log 'executing npm test in root directory'

    @runTask "cd #{@appRoot} && npm test"

  alertFilter: (stdout, stderr, writeError) ->
    if stdout.match /uncaughtException/g
      writeError stdout

    if 'customError' of @item and item.customError
      if stdout.match(
        @item.customError
      )
        writeError stdout


module.exports = NPMTest

