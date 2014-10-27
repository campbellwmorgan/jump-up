###
See each of the modules
in the lib/modules
directory for specifications

Each part must have
  type: [the type specified at the top of each module]
  dir: [the relative path to root to watch in] (must have trailing /)

###
module.exports =
  # this is runs the unit tests
  # for jump up
  default:
    root: __dirname + '/'
    parts: [
      {
        type: 'coffeelint'
        dir: 'lib/'
      }
      {
        type: 'jasmine-local'
        testDir: 'test/'
        perFile: true
        dir: 'lib/'
        coffee: true
        verbose: true
        debounce: 100
      }
    ]
  site1:
    root: '/directory1/'
    parts:[
      {
        type: 'coffee'
        dir: 'public/coffee/'
        outputDir: 'public/javascripts/'
      }
      {
        type: 'sass'
        dir: 'public/sass/'
        singleFile:[
          {
            input: 'style.sass'
            output: '../stylesheets/style.css'
          }
        ]
      }
    ]
  phpApp:
    root: '/home/user/phpApp/'
    parts:[
      {
        type: 'php'
        dir: 'app/'
      }
      {
        type: 'phpunit'
        dir: 'app/'
        test: 'test/'
      }
      {
        type: 'custom'
        description: 'Launches the php server'
        bootstrap: 'cd /home/user/section2 && php -S localhost:8000'
      }
    ]
