
{config} = require "./config"
express = require "express"
path = require "path"
app = express()

rootTo = (dest) ->
  path.join __dirname, "../" + dest

console.log __dirname

app.configure ->
  app.set "views", (rootTo "view")
  app.set 'view engine', 'jade'
  app.use app.router

  app.use "/style", (express.static (rootTo "style"))
  app.use "/client", (express.static (rootTo "client"))
  app.use "/src", (express.static (rootTo "src"))
  app.use "/bower", (express.static (rootTo "bower_components"))

app.get "/", (req, res) ->
  options = 
    developing: config.dev
  res.render "index", options

app.listen config.port
console.log "server listening at", config.port