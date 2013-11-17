
express = require "express"
cors = require "cors"
app = express()

config = require "./config"

mongo = require 'mongo-lite'
db = mongo.connect config.db, ["all"]

db.all.ensureIndex user: -1, (err) ->
  console.log "ensureIndex"

app.use express.bodyParser()
app.use cors()

app.get "/", (req, res) ->
  db.all.first user: "jiyinyiyong", (err, docs) ->
    if err?
      res.json 500, {info: err.toString()}
    else
      delete docs.pass
      res.json 200, docs

app.post "/", (req, res) ->
  query =
    user: "jiyinyiyong"
    pass: req.body.pass or "wrong"
  console.log "query is", query
  db.all.update query, req.body, (err) ->
    if err?
      res.json 500, {info: err.toString()}
    else
      res.json 200, {info: "done"}

app.options "/", (req, res) ->
  res.json {}

app.listen config.port