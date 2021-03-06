describe 'EWS', ->
  EngineWebsocketServer = require('../lib/ews/ew_server')
  EngineWebsocketSlave = require('../lib/ews/ew_slave')
  WebsocketInitiator = require('../lib/ews/ws_initiator')

  options = {
    journalname: "testjournal"
  }

  beforeEach (finish) ->
    @engine_server = new EngineWebsocketServer()
    @engine_server.start().then =>
      finish()

  afterEach (finish) ->
    @engine_server.stop().then =>
      finish()

  xit 'should listen and be connectable', (finish) ->
    stump.info('started')

    wsi = new WebsocketInitiator( {wsconfig: 'ws://localhost:6150/'} )
    wsi.connect().then =>
      wsi.execute_operation(
        {
          kind: "ADD_DEPOSIT"
          account: "peter"
          amount: "5"
          currency: 'BTC'
        }
      ).then (retval) =>
        stump.info 'GOT RETVAL', retval
        finish()
    .done()

  it 'should replicate', (finish) ->
    slave = new EngineWebsocketSlave( {wsconfig: 'ws://localhost:6150/'} )
    slave.connect_upstream().then =>
      stump.info 'CONNECTED UPSTREAM'
      wsi = new WebsocketInitiator( {wsconfig: 'ws://localhost:6150/'} )
      wsi.connect().then =>
        wsi.execute_operation(
          {
            kind: "ADD_DEPOSIT"
            account: "peter"
            amount: "5"
            currency: 'BTC'
          }
        ).then (retval) =>
          stump.info 'GOT RETVAL', retval
          finish()
