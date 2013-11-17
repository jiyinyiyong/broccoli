
define (require, exports) ->
  layoutTmpl = require "text!view/layout.mustache"
  articleTmpl = require "text!view/article.mustache"
  tableTmpl = require "text!view/table.mustache"

  ajax = require "client/ajax"
  db = "http://broccoli.blog/"
  db = "http://broccoli.jiyinyiyong.info/"

  Ractive = require "Ractive"
  marked = require "marked"
  marked.setOptions
    breaks: yes
    gfm: yes

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
      list: {}

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
    if aPost.title.length > 0
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
    layout.set "inTable", yes

  table.observe "query", (newValue) ->
    words = newValue.split(" ")
    data = table.get "list"
    Object.keys(data).map (id) ->
      show = words.every (word) ->
        word = word.toLowerCase()
        title = data[id].title.toLowerCase()
        title.indexOf(word) >= 0
      table.set "list.#{id}.hide", (if show then "" else "hide")

  layout.on "sync", (event) ->
    data =
      data: exportList (table.get "list")
      pass: window.pass or "wrong"
      user: "jiyinyiyong"
    console.log "data:", data
    ajax.post db, data,
      ->
        layout.set "modified", no
      ->
        alert "update failed"

  try do ->
    data = JSON.parse (localStorage.getItem "database")
    # table.set "list", data
  window.addEventListener "beforeunload", ->
    data = exportList table.get('list')
    localStorage.setItem "database", data

  exportList = (list) ->
    data = {}
    for key, value of list
      data[key] = value
    data

  ajax.get db,
    (data) ->
      table.set "list", data.data
    ->
      console.log "fail"
