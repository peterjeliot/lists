class App.views.ItemFormView extends Backbone.View
  events:
    'submit .item__form': 'save'

  initialize: (item) ->
    @item = item

  render: ->
    $template = HandlebarsTemplates['item_form'](@item)
    @$el.html $template

  save: (event) ->
    event.preventDefault()
    data = $(event.currentTarget).serializeArray()
    for datum in data
      attrName = datum.name.match(/item\[(.*)\]/)[1]
      @item[attrName] = datum.value
    @trigger("item:save")
    @item
