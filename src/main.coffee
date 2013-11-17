
define (require, exports) ->
  layoutTmpl = require "text!view/layout.mustache"
  articleTmpl = require "text!view/article.mustache"
  tableTmpl = require "text!view/table.mustache"

  Ractive = require "Ractive"
  marked = require "marked"
  marked.setOptions
    breaks: yes
    gfm: yes

  database = {}
  try
    database = JSON.parse (localStorage.getItem "database")
  window.addEventListener "beforeunload", ->
    localStorage.setItem "database", (JSON.stringify database)


  layout = new Ractive
    el: '#app'
    template: layoutTmpl
    data:
      inTable: yes
      showTable: (inTable) ->
        if inTable then "" else "hide"
      showArticle: (inTable) ->
        if inTable then "hide" else ""
      modified: no

  table = new Ractive
    el: '#table'
    template: tableTmpl
    data:
      list: database

  article = new Ractive
    el: '#article'
    template: articleTmpl
    data:
      title: ""
      content: ""
      time: ""
      markup: (content) ->
        marked content
      editing: no
      hideEditor: (editing) ->
        if editing then "" else "hide"
      hidePreview: (editing) ->
        if editing then "hide" else ""
      showTime: (timestamp) ->
        time = new Date timestamp
        time.toDateString()

  table.on "post", (event) ->
    layout.set "inTable", no
    article.set
      time: (new Date).getTime()
      title: ""
      content: ""
      editing: yes
      id: (new Date).getTime()
      more: no

  layout.on "back", (event) ->
    layout.set "inTable", yes

  article.on "edit", (event) ->
    article.set "editing", yes

  article.on "save", (event) ->
    article.set "editing", no
    data = article.get()
    aPost =
      title: data.title
      content: data.content
      time: (new Date).getTime()
      id: data.id
    if post.title.length >= 9
      table.set "list.#{aPost.id}", aPost
      layout.set "modified", yes

  table.on "open", (event) ->
    data = event.context
    article.set
      title: data.title
      content: data.content
      id: data.id
      time: data.time
      editing: no
      more: no
    layout.set "inTable", no

  article.on "more", ->
    more = article.get "more"
    if more
      article.set "more", no
    else
      article.set "more", yes

  article.on "delete", (event) ->
    id = article.get("id")
    table.set "list.#{id}", undefined
    delete database[id]
    layout.set "inTable", yes

  table.observe "query", (newValue) ->
    words = newValue.split(" ")
    Object.keys(database).map (id) ->
      show = words.every (word) ->
        word = word.toLowerCase()
        title = database[id].title.toLowerCase()
        title.indexOf(word) >= 0
      table.set "list.#{id}.hide", (if show then "" else "hide")