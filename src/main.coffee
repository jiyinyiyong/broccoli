
define (require, exports) ->
  layoutTmpl = require "text!view/layout.mustache"
  articleTmpl = require "text!view/article.mustache"
  tableTmpl = require "text!view/table.mustache"

  Ractive = require "Ractive"
  marked = require "marked"

  layout = new Ractive
    el: '#app'
    template: layoutTmpl
    data:
      inTable: yes
      showTable: (inTable) ->
        if inTable then "" else "hide"
      showArticle: (inTable) ->
        if inTable then "hide" else ""

  table = new Ractive
    el: '#table'
    template: tableTmpl
    data: {}

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

  table.on "post", (event) ->
    layout.set "inTable", no
    article.set "time", (new Date).toDateString()
    article.set "title", ""
    article.set "content", ""
    article.set "editTime", undefined

  layout.on "back", (event) ->
    layout.set "inTable", yes

  article.on "edit", (event) ->
    article.set "editing", yes

  article.on "save", (event) ->
    article.set "editing", no