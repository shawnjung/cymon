class Room extends Backbone.Model
  initialize: ->
    @users = new App.Collection.Users [], model: App.Model.User

module.exports = Room