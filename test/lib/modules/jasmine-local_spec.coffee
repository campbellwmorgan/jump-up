appRoot = __dirname + '/../../../'
JasmineLocal = require appRoot + 'lib/modules/jasmine-local.coffee'

describe "Jasmine-Local tests", ->

  jL = false

  beforeEach ->
    jL = new JasmineLocal (->), appRoot
    ,
      dir: 'lib/'
      testDir: 'test/'
      debounce: 1

  describe "_getTarget", ->

    it "should return testdir if whole directory specified", ->
      item =
        testDir: 'test/'
        perFile: false

      expect(jL._getTarget(item, ''))
        .toBe('test/')

    it "should return original version of file if it exists", ->
      item =
        testDir: 'test/'
        perFile: true
        coffee: true

      result = jL._getTarget item, __filename

      expect(result)
        .toMatch /jasmine-local_spec.coffee/

    it "should return false if file doesnt exist", ->
      item =
        testDir: 'test/'
        perFile: true

      result = jL._getTarget item, __dirname + '/wrong.coffee'

  describe "_getBasename", ->

    it "should replace spec and the extension", ->

      expect(jL._getBasename('logn-a.sd.-test_spec.coffee'))
        .toBe('logn-a.sd.-test')





