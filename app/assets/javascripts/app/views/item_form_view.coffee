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
    console.log "/items/#{@item.id}"
    $.ajax({
      type: "PATCH",
      url: "/items/#{@item.id}",
      data: { item: @item },
      # TODO: Render error on failure
    });
    @trigger("item:save")
    @item
