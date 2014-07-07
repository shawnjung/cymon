class Cymon.User extends Backbone.Model
  idAttribute: 'token'
  defaults:
    token: null
    name: null
    current_room: null


  initialize: (attributes, options)->
    @retrieve_token() unless @attributes.token

  is_registered: -> Boolean @get 'token'

  is_playing: -> @is_registered() and Boolean(@get 'current_room')


  retrieve_token: ->
    @set 'token', $.cookie('cymon_user_token')

  remember_token: ->
    $.cookie 'cymon_user_token', @get 'token', path: '/'

  remove_token: ->
    @set 'token', null
    $.removeCookie 'cymon_user_token'