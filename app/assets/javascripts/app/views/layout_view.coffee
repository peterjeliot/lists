class App.views.LayoutView extends Backbone.View
  initialize: (opts) ->
    @items = opts.data
    @render()

  render: ->
    @$el.html HandlebarsTemplates['layout']()

    for item in @items
      itemView = new App.views.ItemView(item)
      @$el.find('.main-list').append itemView.render()

    @$el.find(".main-list, .main-list ol").sortable {
      connectWith: ".main-list, .main-list ol",
      placeholder: "ui-state-highlight",
      start: (event, ui) ->
        ui.placeholder.height(ui.item.height())
    }
