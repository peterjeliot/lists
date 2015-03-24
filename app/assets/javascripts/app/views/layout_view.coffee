class App.views.LayoutView extends Backbone.View
  initialize: (opts) ->
    @items = opts.data
    @childViews = (new App.views.ItemView(item) for item in @items) || []
    @render()
    @flatItems = @flattenItems(@items)

  render: ->
    @$el.html HandlebarsTemplates['layout']()

    for view in @childViews
      @$el.find('.main-list').append view.render()

    @$el.find(".main-list, .main-list ol").sortable
      connectWith: ".main-list, .main-list ol"
      placeholder: "ui-state-highlight"
      distance: 10
      start: (event, ui) =>
        ui.placeholder.height ui.item.height()
      stop: (event, ui) =>
        @rebuildItems()
        @saveOrder(event, ui)

  rebuildItems: (event, ui) =>
    $(".main-list ol").each (ind, el) =>
      id = el.parentElement.parentElement.id
      item = @flatItems[id]
      childIds = $(el).sortable("toArray")
      item.children = []
      childIds.forEach (id) =>
        item.children.push(@flatItems[id])
    $(".main-list").each (ind, el) =>
      childIds = $(el).sortable("toArray")
      @items = []
      childIds.forEach (id) =>
        @items.push(@flatItems[id])

  flattenItems: (items, result = {}) ->
    # Take a nested list, return a hash with key=id, val=item
    items.forEach (item) =>
      result[item.id] = item
      @flattenItems(item.children, result)
    result

  saveItems: ->
    # Super long because it's navigating the DOM.
    # Not ideal becase this depends on how the HTML is structured.
    parentId = ui.item.parent().parent().parent().attr("id") || null
    childId = ui.item.attr("id")
    # Update order
    ui.item.siblings().andSelf().each (ind, el) ->
      $.ajax
        type: "PATCH"
        url: "/items/#{el.id}"
        data:
          item:
            position: ind
    # Update the parent
    $.ajax
      type: "PATCH"
      url: "/items/#{childId}"
      data:
        item:
          parent_id: parentId
