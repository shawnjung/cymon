class ErrorHandler
  templates:
    validation_error: (options)->
      { message: options.model.validationError }

  constructor: (options)->
    @app = options.app

  render: (template, options) ->
    socket = options.socket
    socket.emit template, @templates[template] options



module.exports = ErrorHandler