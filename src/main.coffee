
define (require, exports) ->

  $("body").keydown (e) ->
    # log e.keyCode
    switch e.keyCode
      when 27 then $("#popup").fadeOut()

  require "./search"
  popup = require "./popup"
  search = require "./search"

  $("#search").keydown (e) ->
    # log e.keyCode
    if e.keyCode in [13, 32]
      keys = popup.split_tags $(@).val()
      search.search keys

  $("#login").click -> popup.auth()
  $("#create").click -> popup.create()

  $("#popup").click (e) ->
    if e.target.id is "popup" then popup.hide()

  # delay 400, -> $("#create").click()
  delay 400, -> search.search []

  exports