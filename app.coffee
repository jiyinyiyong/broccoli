
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
  log "at fetch", result
  if result then fetch req.body, (json) ->
    log "fetch json", json
    json.auth = result
    res.json json
  else res.json auth: result

app.post "/remove", (req, res) ->
  result = check req
  if result then remove req.body, (json) ->
    res.json auth: result
  else res.json auth: result

fs = require "fs"
dot = require "dot"
app.get "/blog/:id", (req, res) ->
  query = id: req.params.id
  # log "query", query
  one query, (json) ->
    blog_html = fs.readFileSync (__dirname + "/server/blog.html")
    page_fn = dot.template blog_html
    page = page_fn json
    # log "json", json, page
    # res.json json
    res.send page