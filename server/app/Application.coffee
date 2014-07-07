class Application
  constructor: (options)->
    @io    = require('socket.io').listen options.port
    @users = new CymonServer.Collection.Users [], model: CymonServer.Model.User
    @users.define_room_events io: @io

    @io.sockets.on 'connection', (socket) =>
      @_bind_events socket

  events:
    'register': 'register'
    'current_users': 'render_current_users'
    'join': 'join'
    'leave': 'leave'
    'disconnect': 'mark_as_offline'


  register: (socket, params) ->
    user = new CymonServer.Model.User params
    user = retrieved_user if retrieved_user = @users.get params.token

    if user.isValid()
      user.mark_as_online()
      socket.user = user
      socket.emit 'register_success', socket.user.attributes

      @users.add user

    else
      socket.emit 'register_error', type: 'validation', message: user.validationError


  render_current_users: (socket) ->
    socket.emit 'current_users_success', @users.toJSON()


  join: (socket, params) ->
    socket.join params.name
    socket.emit 'join_success', params

  leave: (socket, params) ->
    socket.leave params.name
    socket.emit 'leave_success', params


  mark_as_offline: (socket) ->
    socket.user.mark_as_offline() if socket.user



  _bind_events: (socket)->
    _(@events).each (method_name, event_name) =>
      if @[method_name]
        method = _.bind @[method_name], this
        socket.on event_name, (params) => method socket, params


module.exports = Application