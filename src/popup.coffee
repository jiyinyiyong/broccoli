
define (require, exports) ->

  exports.elem = popup = $ "#popup"
  paper = $ "#paper"
  login = $ "#login"

  ajax = require "./ajax"

  login.click ->
    exports.auth()

  article = (data) ->
    $ lilyturf.dom ->
      @div class: "article",
        @div class: "title", (@text data.title)
        @div class: "time", (@text data.time)
        @div class: "content", (@text data.content)

  auth = ->
    elem = lilyturf.dom ->
      @input class: "password"

    $(elem).keydown (e) ->
      if e.keyCode in [13, 32]
        password = $(elem).val() 
        ajax.auth password
        localStorage.setItem "password", password

    button = lilyturf.dom ->
      @div class: "button", (@text "submit")

    $(button).click ->

    $ lilyturf.dom ->
      @div class: "auth",
        elem,
        @div class: "button submit",

  editor = (data) ->
    $ lilyturf.dom ->
      @div class: "editor",
        @input class: "title"
        @textarea class: "content"
        @button class: "save", (@text "save")

  exports.article = (data) ->
    popup.fadeIn()
    ajax.fetch data, (item) ->
      data.content = item.content
      data.time = item.time
      paper.empty().append (article data)

  exports.auth = ->
    popup.fadeIn()
    paper.empty().append auth()

  exports.editor = (data) ->
    popup.fadeIn()
    ajax.fetch data, (item) ->
      data.content = item.content
      paper.empty().append (editor data)

  exports