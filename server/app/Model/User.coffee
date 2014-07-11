class User extends Backbone.Model
  idAttribute: 'token'
  defaults:
    token: null
    name: null
    current_room: null
    online: null
    connected_at: null
    disconnected_at: null

  initialize: ->
    @set 'token', uuid.v1()
    @on 'change', => @collection.trigger 'update', this if @collection

  validate: (attr, options) ->
    return 'Name required.' unless attr.name


  is_registerable: ->
    result = @isValid()
    if @socket
      @validationError = 'This user is already connected.'
      result = false
    return result

  set_current_room: (room) ->
    unless @current_room
      @current_room = room
      @set 'current_room', room.get 'token'
    else
      false

  remove_current_room: ->
    @current_room = null
    @set 'current_room', null


  set_socket: (socket) ->
    socket.user = this
    @socket = socket
    true

  remove_socket: ->
    @socket.user = undefined
    @socket = undefined
    true


  invite: (user_token) ->




  mark_as_online: ->
    @set online: true, connected_at: new Date()

  mark_as_offline: ->
    @set online: false, disconnected_at: new Date()

module.exports = User