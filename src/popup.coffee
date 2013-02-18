
define (require, exports) ->

  exports.elem = popup = $ "#popup"
  paper = $ "#paper"

  config = require "./config"
  backend = require "./backend"

  marked.setOptions
    gfm: yes
    breaks: yes
    sanitize: no

  my =
    new: -> @id = (new Date).getTime().toString()
    data: {}
  my.new()

  exports.split_tags = split_tags = (str) ->
    str.split(" ").filter (s) -> s[0]?

  article_data = ->
    data =
      id: my.id
      tags: split_tags paper.find(".tags").val()
      title: paper.find(".title").val()
      content: paper.find("textarea").val()

  auth = ->
    $ lilyturf.dom ->
      @div class: "auth",
        @input class: "password", type: "password"

  editor = (data) ->
    tags = if data.tags? then data.tags.join " " else ""

    $ lilyturf.dom ->
      @div class: "editor vertical-list",
        @input class: "tags", value: tags
        @input class: "title", value: (data.title or "")
        @textarea class: "content",
          @text (data.content or "")
        @div class: "control horizontal",
          @div class: "save button", (@text "Save")
          @div class: "preview button", (@text "Preview")
          @div class: "remove button", (@text "Remove")
          @div class: "exit button", (@text "Exit")

  preview = (data) ->
    $ lilyturf.dom ->
      @div class: "preview article vertical-list",
        @code class: "tags", (@text (data.tags.join " "))
        @div class: "title", (@text data.title)
        @div class: "content",
          @html (marked data.content)
        @div class: "control horizontal",
          # @div class: "save button", (@text "Save")
          @div class: "edit button", (@text "Edit")

  reader = (data) ->
    link = "/blog/#{data.id}"
    $ lilyturf.dom ->
      @div class: "reader article vertical-list",
        @code class: "tags", (@text (data.tags.join " "))
        @div class: "title", (@text data.title)
        @div class: "line",
          @code class: "time", (@text data.time)
          @a href: link, target: "_blank",
            @text "direct link"
        @div class: "content",
          @html (marked data.content)
        @div class: "control horizontal",
          @div class: "edit button", (@text "Edit")

  exports.auth = ->
    exports.show()
    paper.empty().append auth()
    paper.find("input").focus().keydown (e) ->
      if e.keyCode in [13, 32]
        password = $(@).val() 
        backend.auth password
        localStorage.setItem "password", password

  exports.reader = (data) ->
    my.id = data.id
    exports.show()
    backend.fetch data, (item) ->
      data.content = item.content or ""
      data.time = item.time
      # log "editor:", data, item
      paper.empty().append (reader data)
      paper.find(".edit").click ->
        exports.edit data

  exports.create = ->
    exports.show()
    my.new()
    exports.edit {}

  exports.preview = ->
    data = article_data()
    my.data = data
    paper.empty().append (preview data)
    paper.find(".edit").click -> exports.edit data
    # paper.find(".save").click -> backend.update data

  exports.edit = (data) ->
    paper.empty().append (editor data)
    paper.find(".tags").focus()
    paper.find(".save").click ->
      backend.update article_data()
      exports.preview()  
    paper.find(".preview").click -> exports.preview()
    paper.find(".exit").click -> exports.hide()
    paper.find(".remove").click ->
      backend.remove data, -> exports.hide()

  exports.show = -> popup.fadeIn config.fadeIn_duration
  exports.hide = ->
    popup.fadeOut config.fadeOut_duration, ->
      $("#search").focus()

  exports