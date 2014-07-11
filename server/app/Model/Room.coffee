class Room extends Backbone.Model
  idAttribute: 'token'
  defaults:
    token: ''
    limit: 2
    current_turn: -1
    current_level: 1
    maxium_step:
    ended: false
    private: true

  initialize: ->
    @set 'token', uuid.v1()
    @users = new App.Collection.Users [], model: App.Model.User
    @levels = new App.Collection.Levels [], model: App.Collection.Level


  # before starting game

  join: (socket) ->
    user = socket.user
    if user.set_current_room this
      @users.add this
      socket.join @get 'token'
      true
    else
      false

  join_as_owner: (socket) ->
    @set_owner socket.user
    @join socket

  leave: (socket) ->
    @users.remove user
    socket.leave @get 'token'
    socket.user.remove_current_room()

  set_owner: (user) ->
    @owner = user

  start_game: (options)->
    return false unless @is_startable user: options.by
    @set 'current_turn', 0
    @queue.reset_steps()
    @users.each (user) ->
      user.socket.emit 'start_game', current_turn: @get('current_turn')
    true


  # after started game

  record_queue: (options) ->
    return false unless @is_recordable user: options.user
    # write more



  end_game: ->






  # extra methods

  is_started: ->
    @get('current_turn') >= 0

  is_owner: (user) ->
    @owner is user

  is_ended: ->
    @get 'ended'

  is_my_turn: (user) ->
    @models[@get 'current_turn'] is user

  is_recordable: (options)->
    @clear_error_message()

    switch true
      when not @is_started()
        @set_error_message "The game hasn't been started yet."
      when not @is_ended()
        @set_error_message "The game is ended."
      when not @is_my_turn options.user
        @set_error_message "It's not your turn."

    return false if @latest_error
    true


  is_startable: (options)->
    @clear_error_message()

    switch true
      when not @is_owner options.user
        @set_error_message "Only a owner start game."
      when @is_started()
        @set_error_message "The game is already started."
      when @users.length < 2
        @set_error_message "You cannot start game alone."

    return false if @latest_error
    true



  set_error_message: (message) ->
    @latest_error = message

  clear_error_message: ->
    @latest_error = null

  get_socket_room: (options) ->
    @io.sockets.to @get 'token'

  define_io: (io) ->
    @io = io




  toJSON: ->
    output = _.clone(@attributes)
    output.users = @users.toJSON()
    output



module.exports = Room