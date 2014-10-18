appRoot = __dirname + '/../../../'
Base = require appRoot + 'lib/modules/base.coffee'
describe "Module Base class", ->

  base = false


  describe "debounced runtask", ->
    it "Should delay execution of runTask", (done) ->

      runTask =
        run: ->

      spyOn(runTask, 'run')

      base = new Base runTask.run, appRoot
      ,
        dir: 'test/lib/modules'
        debounce: 100

      base.runTask 'test'

      expect(runTask.run).not.toHaveBeenCalled()

      setTimeout ->
        expect(runTask.run).toHaveBeenCalled()
        done()
      , 150







