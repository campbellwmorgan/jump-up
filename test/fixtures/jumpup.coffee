module.exports =
  default:
    parts: [
      {
        description: 'run test'
        type: 'custom'
        bootstrap: 'PROCESS_NUMBER=1 node ./demoServer.js'
        debounce: 100
        change: 'PROCESS_NUMBER=2 node ./demoServer.js'
        dir: ['tmp']
        killExisting: true
      }
    ]
