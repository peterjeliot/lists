class App.views.ItemView extends Backbone.View
  events:
    'click .item__title': 'toggleDisplay'
    'click .item__edit': 'showFormView'

  initialize: (item) ->
    @item = item
    @children = item.children
    @childViews = (new App.views.ItemView(child) for child in item.children) || []

  render: ->
    @$el.html $(HandlebarsTemplates['item'](@item))
    @showAttributes()
    $childList = @$el.find(".item__children")
    for childView in @childViews
      childTemplate = childView.render()
      $childList.append childTemplate
    @$el

  toggleDisplay: (event) ->
    event.stopPropagation()
    @$el.find(".item__children").toggle()

  showFormView: (event) ->
    event.stopPropagation()
    formView = new App.views.ItemFormView(@item)
    @listenTo formView, 'item:save', =>
      @showAttributes()
    @$el.find(".item__attributes").first().html(formView.render())

  showAttributes: ->
    attributesTemplate = HandlebarsTemplates['item_attributes'](@item)
    @$el.find(".item__attributes").first().html(attributesTemplate)
