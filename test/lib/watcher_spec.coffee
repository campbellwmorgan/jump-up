watcher = require '../../lib/watcher'

describe "Main watcher", ->

  it "should execute a module when a file changes ", (done)->
    bootstrapRun = false
    class TestModule
      constructor: (@runTask) ->
      start: (filename) =>
        expect(filename)
          .toMatch /testFile.txt$/

        @runTask 'testCommand'

        expect(bootstrapRun)
          .toBe true
        done()
      runBootstrap: (watch, cb) ->
        bootstrapRun = true

    overrides =
      modules:
        'testModule': TestModule
      runTask: (command) ->
        expect(command).toBe 'testCommand'
      argv:
        platform: 'node'
        debug: false
        _: [
          'testsection'
        ]
      log:
        log: ->
        error: ->
      config:
        testsection:
          root: '/test/root/'
          parts:[
            {
              type: 'testModule'
              dir: 'src/'
            }
          ]

      watch: (dir, cb) ->
        expect(dir).toBe '/test/root/src/'
        setTimeout ->
          cb '/test/root/src/testFile.txt'
        , 30

    watcher overrides



