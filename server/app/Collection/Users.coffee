class Users extends Backbone.Collection
  define_io: (io) ->
    @io = io

  define_room_events: (options)->
    @define_io options.io unless @io

    @on 'add', (user) ->
      @io.sockets.to('current_users').emit 'user_added', user.attributes

    @on 'remove', (user) ->
      @io.sockets.to('current_users').emit 'user_removed', user.id

    @on 'update', (user) ->
      @io.sockets.to('current_users').emit 'user_updated', user.attributes



module.exports = Users