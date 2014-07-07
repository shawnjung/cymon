class Cymon.ApplicationView extends Cymon.View
  id: 'cymon-app'
  template: JST['application/tpl/application_view']
  initialize: ->
    @document_body = $("body")
    @_render()
    @_position()


  show_validation_error: (options)->
    model = options.model
    alert model.validationError



  _render: ->
    @$el.html @template()
    @body = @$el


  _position: ->
    @document_body.prepend @el