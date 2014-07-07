class Cymon.Users.UserItem extends Cymon.View
  tagName: 'li'
  template: JST['application/tpl/users/user_item']

  initialize: ->
    @_render()
    @_position()

  refresh: ()->
    @_render()

  _render: ->
    @$el.html @template @model.toJSON()

  _position: ->
    @parent.user_list.append @el