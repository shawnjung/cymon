class Cymon.View extends Backbone.View
  constructor: (options) ->
    @app    = options.app
    @parent = options.parent
    super options
    @_bind_socket_events() if @socket_events
    @_join_socket_room() if @socket_room


  _bind_socket_events: ->
    socket = @app.communicator.socket

    _(@socket_events).each (method_name, event_name) =>
      if @[method_name]
        method = _.bind @[method_name], this
        socket.on event_name, (params) => method socket, params

  _unbind_socket_events: ->
    socket = @app.communicator.socket
    _(@socket_events).each (method_name, event_name) =>
      socket.off event_name if @[method_name]


  _join_socket_room: ->
    @app.communicator.request 'join', name: @socket_room,
      success: => console.log "joined room : #{@socket_room}"

  _leave_socket_room: ->
    @app.communicator.request 'leave', name: @socket_room,
      success: => console.log "left room : #{@socket_room}"


  remove: ->
    @_leave_socket_room() if @socket_room
    @_unbind_socket_events() if @socket_events
    super