appRoot = __dirname + '/../../../'
NPMTest = require appRoot + 'lib/modules/npm-test.coffee'

describe "NPMTest Tests", ->
  nT = false
  testRoot = '/test/dir/'
  ite = false
  beforeEach ->
    ite =
      dir: 'test/one/two'
      regex: /\.coffee/
      debounce: 1
      customError: /FAILED/g
    nT = new NPMTest (->), testRoot
    , ite

  describe "run", ->

    it "should reject files where regex doesnt match", ->

      result = nT.run(ite, '/test/dir/test/one/two/test.js')
      expect(result)
        .toBe false

    it "should call run task with the app root", () ->
      spyOn nT, 'runTask'
      nT.run ite, '/test/dir/test/one/two/test.coffee'

      expect(nT.runTask)
        .toHaveBeenCalledWith('cd /test/dir/ && npm test')


  describe "alertFilter", ->
    it "should writeError when stdout matches customError", ()->
      alerted = false
      nT.alertFilter "adsf asdf asdj \n FAILED \d \n", {}
      ,  ->
        alerted = true

      expect(alerted)
        .toBe true


