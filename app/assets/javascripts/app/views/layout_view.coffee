class App.views.LayoutView extends Backbone.View
  initialize: (opts) ->
    @items = opts.data
    @childViews = (new App.views.ItemView(item) for item in @items) || []
    @render()
    console.log @flattenItems(@items)

  render: ->
    @$el.html HandlebarsTemplates['layout']()

    for view in @childViews
      @$el.find('.main-list').append view.render()

    @$el.find(".main-list, .main-list ol").sortable
      connectWith: ".main-list, .main-list ol"
      placeholder: "ui-state-highlight"
      distance: 10
      start: (event, ui) ->
        ui.placeholder.height ui.item.height()
      stop: @rebuildItems

  rebuildItems: (event, ui) =>
    # parentId = event.target.parentElement.parentElement.id
    # parentItem =
    @rebuildChildren @items, @childViews, @flattenItems(@items)
    console.log @items

  rebuildChildren: (list, views) ->
    $(views).each (ind, view) =>
      item = view.item
      item.position = ind
      list.push(item)
      item.children = []
      @rebuildChildren(item.children, view.childViews)

  flattenItems: (items, result = {}) ->
    # Take a nested list, return a hash with key=id
    items.forEach (item) =>
      result[item.id] = item
      @flattenItems(item.children, result)
    result
