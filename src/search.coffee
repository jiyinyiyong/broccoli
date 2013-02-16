
define (require, exports) ->

  ajax = require "./ajax"
  popup = require "./popup"
  search = $("#search").focus()
  table = $ "#table"

  card = (data) ->
    $ lilyturf.dom ->
      @div class: "card",
        @div class: "title", (@text data.title)
        @div class: "", (@text data.title)

  query = (key) ->
    ajax.search key, (list) ->
      log list

  tags = require("./config").tags
  tags.forEach (tag) ->
    elem = $ lilyturf.dom ->
      @div class: "tag", (@text tag)
    $("#tags").append elem
    elem.click -> query tag

  exports