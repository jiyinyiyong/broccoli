
config = require("./server/config").config
{index, content} = require "./server/store"

log = console.log

make =
  id: -> (new Date).getTime().toString()

express = require("express")
app = express()
app.listen config.port

app.use express.bodyParser()
app.use "/page", express.static(__dirname + '/page')
app.use "/components", express.static(__dirname + '/components')

app.get "/", (req, res) ->
  res.redirect "/page/"

app.post "/auth", (req, res) ->
  result = req.body.password is config.password
  res.json auth: result