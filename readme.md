JumpUp
=================

A command-line tool for watching file changes
and then executing cli commands.

By default it listens to STDOUT and STDERR for
module-dependent triggers then uses the node-notifier
to defer to platform-specific desktop notifications

N.B You MUST install all command line utilities separately


###Installation

        npm install jumpup -g

###Usage

        jumpup [options] <section1> <section2> ...

        Options:
          --config a .js or .coffee config file (see watchAreas.example)

###Why not Gulp-watch or grunt-watch?

Gulp watch and grunt watch are great workflow tools, but when
working in development environments which depend on more
than one service or programming language creating a single "God" grunt/gulpfile
or opening multiple terminal windows to run them is cumbersome and slows
down the dev process.

Jump-Up solves this by enabling each service/language to have its own gulp/grunt
file or a test/make file which can be triggered on change and can all be
launched simultaneously from one command eg:

          jumpup phpServer nodeJSService goServer


###Config File

See "jumpup.coffee" for an example coffeescript config file


###Modules

####CleanCSS

  Executes cleancss

  Config Example:

          type: 'cleancss'
          input: 'myinput.css'
          output: 'myoutput.css'
          dir: 'cssDir/'

####Coffee

  Executes coffee

  Config Example:

          type: 'coffee'
          recursive: true # runs coffee recursively in dir
          outputDir: 'dist/'
          dir: 'coffee/'


####CoffeeLint

  Executes coffeelint

  Config Example:

          type: 'coffeelint'
          dir: 'coffee/'

####Custom

  Executes custom commands

  Config Example:

          type: 'custom'
          dir: 'liveContent/'

          # amount of time in ms
          # to debounce / delay
          debounce: 500

          # 'change' is run whenever
          # a file in 'dir' is modified
          # this would restart
          change: 'node app --dev'

          # run once on load - good for
          # running the development server
          bootstap: 'node app --dev'

          # should any running
          # instances of this task
          # be killed before running a new one
          killExisting: true


####Gulp

  Executes Gulp

  Config Example:

          type: 'gulp'
          dir: ['coffee','sass'] # or 'coffee'
          regex: /*.coffee/ # only run
          section: 'sass' # name of the gulp action


####Grunt

  Executes grunt

  Config Example:

          type: 'grunt'
          regex: /*.coffee/ # only run if this matches
          dir: 'coffee/'

####JasmineLocal

  Executes jasmine-node in the ./node_modules/.bin directory

  Config:

          type: 'jasmine-local'
          testDir: 'test/unit/' # directory where tests are located
          perFile: true # only executes the test for the file changed
          dir: 'main-scripts/'

          coffee: true # run with the --coffee flag

          # number of ms to debounce
          # (prevents tests being run too
          # many times on double-save)
          Debounce: 100

          verbose: true # run with the --verbose flag
          # any environmental variables to precede the
          # execution
          env: [
            'NODE_ENV':'testing'
          ]


####JasmineNode

  Executes the global instance of jasmine-node

  Config

        type: 'jasmine-node'
        testDir: 'test/unit/' # directory where tests are located
        perFile: true # only executes the test for the file changed
        dir: 'main-scripts/'
        coffee: true # run with the --coffee flag

        # number of ms to debounce
        # (prevents tests being run too
        # many times on double-save)
        Debounce: 100

        verbose: true # run with the --verbose flag

        # any environmental variables to precede the
        # execution
        env: [
          'NODE_ENV':'testing'
        ]


####Karma

  Executes the karma start in a new window

        type: 'karma'
        config: 'relative/path/to/config.js'
        dir: 'karma/'

####NPMTest

  Executes "npm test"

        type: 'npm-test'
        dir: 'watchDir/'

        # custom regex for filematching
        # eg /\.coffee$/
        regex: false

        # custom regex for matching
        # text in stdout for throwing
        # error notifications
        # eg /\.[1-9] Failures/g
        customError: false

####PHP

  Executes php -l (lints php files)

        type: 'php'
        dir: 'phpFiles/'


####PHPUnit

  Executes PHPUnit on selected files

        type: 'phpunit'
        test: 'dir/for/php/specs'
        dir: 'src/folder/'
        oneFile: /justThisFile/ # only run if this file matches


####Protractor

  Executes protractor debouncing with a delay

        type: 'protractor'
        config: 'path/to/config.file.js'
        delay: 1000 # number of ms to debounce before executing


####Sass

  Executes sass

        type: 'sass'
        singleFile: [
          'onlyConvertThisFile.sass'
          'andThisFile.sass'
          ]
        input: 'sourceSassFile.sass'
        output: 'outputFile.css'
        style: 'compressed' # nested, compact, expanded

        # additional load path(s)
        # can be an array of load paths instead
        loadPath: '/path/to/bourbon'



Licence is MIT

Pull Requests welcome

Author Campbell Morgan <campbellmorgan@gmail.com>

