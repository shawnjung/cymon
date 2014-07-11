class Application
  constructor: (options)->
    @io    = require('socket.io').listen options.port
    @users = new App.Collection.Users [], model: App.Model.User
    @rooms = new App.Collection.Rooms [], model: App.Model.Room

    @users.define_lobby_events io: @io

    @io.sockets.on 'connection', (socket) =>
      @_bind_events socket


  events:
    # basic actions

    'register': 'register'
    'join': 'join'
    'leave': 'leave'
    'disconnect': 'mark_as_offline'


    # lobby actions

    'current_users': 'render_current_users'
    'make_room': 'make_room'
    'join_room': 'join_room'
    'leave_room': 'leave_room'
    'start_game': 'start_game'


    # in game actions
    'record_queue': 'record_queue'



  # basic actions

  register: (socket, params) ->
    user = new App.Model.User params
    user = retrieved_user if retrieved_user = @users.get params.token

    if user.is_registerable()
      user.mark_as_online()
      user.set_socket socket
      socket.emit 'register_success', socket.user.attributes

      @users.add user

    else
      socket.emit 'register_error', type: 'validation', message: user.validationError

  join: (socket, params) ->
    socket.join params.name
    socket.emit 'join_success', params

  leave: (socket, params) ->
    socket.leave params.name
    socket.emit 'leave_success', params

  mark_as_offline: (socket) ->
    if socket.user
      socket.user.mark_as_offline()
      socket.user.remove_socket()



  # lobby actions

  render_current_users: (socket) ->
    socket.emit 'current_users_success', @users.toJSON()


  make_room: (socket) ->
    room = new App.Model.Room
    if room.join_as_owner socket
      room.define_io @io
      @rooms.add room
      socket.emit 'make_room_success', room.toJSON()
    else
      socket.emit 'make_room_error', type: 'validation', message: 'Cannot make a room'


  join_room: (socket, params) ->
    room = @rooms.get params.room_token
    if room.join socket
      socket.emit 'join_room_success', room.toJSON()
    else
      socket.emit 'join_room_error', type: 'validation', message: 'Cannot join into the room'


  leave_room: (socket, params) ->




  # game actions

  start_game: (socket, params) ->
    user = socket.user
    room = user.current_room
    if room.start_game by: user
      socket_room = room.get_socket_room io: @io
      socket_room.emit 'start_game'
    else
      socket.emit 'start_game_error', type: 'validation', message: room.latest_error


  record_queue: (socket, params) ->
    user = socket.user
    room = user.current_room
    if room.record_queue user: user, queue: params.queue
      socket_room = room.get_socket_room io: @io
      socket_room.emit 'received_queue'
      unless room.is_my_turn user
        socket_room.emit 'finished_turn', next_turn: room.get 'current_turn', next_level: room.get 'current_level'


    else
      socket.emit 'record_queue_error', type: 'validation', message: room.latest_error
















  _bind_events: (socket)->
    _(@events).each (method_name, event_name) =>
      if @[method_name]
        method = _.bind @[method_name], this
        socket.on event_name, (params) => method socket, params


module.exports = Application