JumpUp
=================

A command-line tool for watching file changes
and then executing cli commands.

By default it listens to STDOUT and STDERR for
module-dependent triggers then executes the Gnome
"notify" command

N.B You MUST install all command line utilities separately


###Installation

        npm install jumpup -g

###Usage

        jumpup [options] <section1> <section2> ...

        Options:
          --config a .js or .coffee config file (see watchAreas.example)
          --platform <gnome|osx> see ./lib/notify.coffee for options


###Config File

See "watchAreas.example" for a coffee-script
config file example


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
          testPrefix: 'test/unit/' # directory where tests are located
          dir: 'main-scripts/'
          coffee: true # run with the --coffee flag
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
        dir: 'src/'


####Karma

  Executes the karma start in a new window

        type: 'karma'
        config: 'relative/path/to/config.js'
        dir: 'karma/'

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
        loadPath: '/path/to/bourbon' # additional load path



Licence is MIT

Pull Requests welcome

Author Campbell Morgan <campbellmorgan@gmail.com>

