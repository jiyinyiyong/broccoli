
config = require("./server/config").config
{create, update, get_index, fetch, remove, one} =
  require "./server/store"

log = console.log

make =
  id: -> (new Date).getTime().toString()

check = (req) -> req.body.password is config.password

express = require("express")
app = express()
app.listen config.port

app.use express.bodyParser()
app.use "/page", express.static(__dirname + '/page')
app.use "/components", express.static(__dirname + '/components')

app.get "/", (req, res) ->
  res.redirect "/page/"

app.post "/auth", (req, res) ->
  res.json auth: (check req)

app.post "/create", (req, res) ->
  result = check req
  res.json auth: result
  if result then create req.body, (err, doc) ->

app.post "/update", (req, res) ->
  result = check req
  res.json auth: result
  if result then update req.body, (err, doc) ->

app.get "/get_index", (req, res) ->
  get_index (json) -> res.json json

app.post "/fetch", (req, res) ->
  result = check req
  # log "at fetch", result
  if result then fetch req.body, (json) ->
    # log "fetch json", json
    if json? then json.auth = result
    res.json (json or {})
  else res.json auth: result

app.post "/remove", (req, res) ->
  result = check req
  if result then remove req.body, (json) ->
    res.json auth: result
  else res.json auth: result

fs = require "fs"
dot = require "dot"
marked = require "marked"

dot.templateSettings =
  strip: no
  interpolate: /\{\{=([\s\S]+?)\}\}/g
  varname: 'it'
marked.setOptions
  gfm: yes
  breaks: yes
  sanitize: no

html_path = __dirname + "/server/blog.html"
p404_path = __dirname + "/server/404.html"
p404_html = fs.readFileSync p404_path, "utf8"
blog_html = fs.readFileSync html_path, "utf8"
page_fn = dot.template blog_html

app.get "/blog/:id", (req, res) ->
  query = id: req.params.id
  # log "query", query
  one query, (json) ->
    # log json
    if json?
      json.tags = json.tags.join " "
      json.content = marked json.content
      json.author = config.author
      json.site = config.site
      page = page_fn json
      # log "json", json, page
      # res.json json
      res.send page
    else
      res.send p404_html