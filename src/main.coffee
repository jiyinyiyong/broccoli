
define (require, exports) ->

  popup = $("#popup").hide()
  $("body").keydown (e) ->
    log e.keyCode
    switch e.keyCode
      when 27 then popup.fadeOut()

  require "./search"

  exports