class Users extends Backbone.Collection
  define_io: (io) ->
    @io = io

  define_lobby_events: (options)->
    @define_io options.io unless @io
    lobby = @io.sockets.to('lobby')

    @on 'add', (user) ->
      lobby.emit 'user_added', user.attributes

    @on 'remove', (user) ->
      lobby.emit 'user_removed', user.id

    @on 'update', (user) ->
      lobby.emit 'user_updated', user.attributes



module.exports = Users