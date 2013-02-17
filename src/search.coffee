
define (require, exports) ->

  backend = require "./backend"
  popup = require "./popup"
  search = $("#search").focus()
  table = $ "#table"

  index =
    data: []
    update: ->
      backend.get_index (json) ->
        index.data = json
        # log "index data:", index.data
  index.update()

  card = (data) ->
    $ lilyturf.dom ->
      @div class: "card",
        @div class: "title button", (@text data.title)
        @div class: "tags"

  render_card = (data) ->
    elem = card data
    table.append elem
    data.tags.forEach (key) ->
      a_tag = $ lilyturf.dom ->
        @div class: "tag button", (@text key)
      elem.find(".tags").append a_tag
      a_tag.click -> exports.search [key]
    elem.find(".title").click -> popup.reader data

  match = (keys, have) ->
    unless keys[0]? then yes
    else 
      while keys[0]?
        if keys[0] in have then return yes
        keys = keys[1..]
      no

  exports.search = (tags) ->
    result = []
    index.data.forEach (item) ->
      if match tags, item.tags
        result.push item
    table.empty()
    # log "result", result, index.data
    result.forEach render_card

  exports