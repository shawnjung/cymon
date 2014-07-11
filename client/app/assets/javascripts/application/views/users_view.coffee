class Cymon.UsersView extends Cymon.View
  template: JST['application/tpl/users_view']
  initialize: (options)->
    @socket = @app.communicator.socket

    @app.communicator.request 'current_users', {},
      success: (users) =>
        @users = new Cymon.CurrentUsers users
        @_render()
        @_render_users()


  socket_room: 'lobby'

  socket_events:
    'user_added': 'add_user'
    'user_updated': 'refresh_user'


  add_user: (socket, user_data)->
    user = new Cymon.User user_data
    @users.add user
    @_render_user_item model: user

  refresh_user: (socket, user_data)->
    user = @users.get user_data.token
    user.set user_data
    @_user_views[user.id].refresh()

  _render: ->
    @$el.html @template()
    @user_list = @$(".user-list")

  _render_users: ->
    @_user_views = {}
    @users.each (user) =>
      @_render_user_item model: user

  _render_user_item: (options = {})->
    view = new Cymon.Users.UserItem app: @app, parent: this, model: options.model
    @_user_views[options.model.id] = view
    view

