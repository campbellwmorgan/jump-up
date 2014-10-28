appRoot = __dirname + '/../../../'
PHPUnit = require appRoot + 'lib/modules/phpunit.coffee'

describe "PHPUnit Tests", ->

  pU = false
  testRoot = '/test/dir/'
  beforeEach ->
    pU = new PHPUnit (->), testRoot
    ,
      dir: 'lib/'
      test: 'test/'
      debounce: 1

  describe "run", ->

    it "should match the directory correctly", ->
      item =
        dir: 'lib/'
        test: 'test/'

      expect(pU.run(item, '/test/dir/lib/item.php'))
        .not.toBe false

      expect(pU.run(item, '/test/dir/wrong'))
        .toBe false

    it "should match items in the test directory", ->

      item =
        dir: 'lib/'
        test: 'test/'

      expect(pU.run(item, '/test/dir/test/item1.php'))
        .not.toBe false




