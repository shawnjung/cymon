class Cymon.Users.UserItem extends Cymon.View
  tagName: 'li'
  template: JST['application/tpl/users/user_item']

  initialize: ->
    @_render()
    @_position()

  events:
    'click': 'request_game'


  request_game: ->
    @app.communicator.request 'request_game', user: @model.id,



  refresh: ()->
    @_render()

  _render: ->
    @$el.html @template @model.toJSON()

  _position: ->
    @parent.user_list.append @el