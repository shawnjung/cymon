class Cymon.LoginView extends Cymon.View
  template: JST['application/tpl/login_view']
  initialize: ->
    @_render()


  events:
    'submit': 'register'


  register: (e)->
    e.preventDefault()
    @model.set @form.serializeObject()
    @app.communicator.request 'register', @model.attributes,
      success: (response) =>
        @model.set response
        @model.remember_token()
        @app.navigate 'users', trigger: true

      error: (response) =>
        @app.view.show_validation_error data



  _render: ->
    @$el.html @template()
    @form = @$("form")