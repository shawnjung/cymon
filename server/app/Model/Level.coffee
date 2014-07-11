class Level extends Backbone.Model
  initialize: (attributes, options) ->
    @queues = new App.Collection.Queues [], model: App.Model.Queue

module.exports = Level