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

  mark_as_online: ->
    @set online: true, connected_at: new Date()

  mark_as_offline: ->
    @set online: false, disconnected_at: new Date()

module.exports = User