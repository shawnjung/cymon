#= require_tree ./application
#= require_self

class Cymon.Application extends Backbone.Router
  initialize: ->
    @user         = new Cymon.User
    @view         = new Cymon.ApplicationView app: this
    @communicator = new Cymon.Communicator app: this

    @communicator.init_current_user @user, =>
      Backbone.history.start()



  routes:
    '': 'redirect_to_init_screen'
    'login': 'show_login'
    'users': 'show_users'
    'play': 'show_game_screen'


  redirect_to_init_screen: ->
    init_screen = switch true
                    when @user.is_playing() then 'play'
                    when @user.is_registered() then 'users'
                    else 'login'

    @navigate init_screen, trigger: true


  show_login: ->
    @render Cymon.LoginView, model: @user

  show_users: ->
    @check_session => @render Cymon.UsersView

  show_game_screen: ->

  check_session: (success_callback) ->
    if @user.is_registered()
      success_callback()
    else
      @navigate 'login', trigger: true



  render: (view_class, options = {})->
    options.app = this
    @_current_view.remove() if @_current_view

    @_current_view = new view_class options
    @view.body.html @_current_view.el
    @_current_view