class Cymon.Communicator
  constructor: (options)->
    @app  = options.app
    @socket = io 'http://localhost:8090'


  init_current_user: (user, callback) ->
    if user.is_registered()
      @request 'register', token: user.get('token'),
        success: => callback()
        error: =>
          user.remove_token()
          callback()

    else
      callback()


  request: (event_name, options = {}, callbacks = {}) ->
    @socket.emit event_name, options

    after_get_response = (response) =>
      @socket.off "#{event_name}_success"
      @socket.off "#{event_name}_error"
      callbacks.complete response if callbacks.complete

    @socket.on "#{event_name}_success", (response) =>
      after_get_response response
      callbacks.success response if callbacks.success


    @socket.on "#{event_name}_error", (response) =>
      after_get_response response
      callbacks.error response if callbacks.error