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


  describe "matchDir", ->
    base = false
    beforeEach ->
      runTask = run: (->)
      base = new Base runTask, appRoot
      ,
        dir: ''
        debounce: 1

    it "should match directory", ->

      expect(
        base.matchDir(
          '/test/one/two/three',
          '/test/one/two/three/four/five'
        )
      ).toBe true

    it "should match multiple directories", ->
      expect(
        base.matchDir(
          [
            '/test/one/two'
            '/test/one/three'
            '/test/other/four'
          ]
          '/test/one/three/five'
        )
      ).toBe true

    it "should fail different directories", ->
      expect(
        base.matchDir(
          [
            '/test/one/two'
            '/test/one/three'
          ]
          '/test/one/four/five/six'
        )
      ).toBe false


