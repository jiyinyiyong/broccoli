
db = require("mongo-lite").connect "mongodb://localhost:27017/blog-server"

index = db.collection "index"
content = db.collection "content"
###

seach data =
  id: 13722222time
  tags: ["tag"]
  title: "string"

content data =
  id: 13722222time
  content: "string string"
  time: "2013-12-13 13:13:14"

###

time = require "time"
format = require "dateformat"

make =
  time: ->
    now = new time.Date
    now.setTimezone "Asia/Shanghai"
    format now, "yyyy-mm-dd hh:MM"

exports.index = {}
exports.content = {}

exports.index.add = (data, call) -> index.insert data, call
exports.index.drop = (data, call) ->
  if data.id? then index.remove {id: data.id}, call
  else call (new Error "no id"), []
exports.index.update = (data, call) ->
  if data.id? then index.update {id: data.id}, data, call
  else call (new Error "no id"), []

exports.content.add = (data, call) ->
  data.time = make.time()
  content.insert data, call
exports.content.drop = (data, call) ->
  if data.id? then content.remove {id: data.id}, call
  else call (new Error "no id"), []
exports.index.update = (data, call) ->
  if data.id? then content.update {id: data.id}, data, call
  else call (new Error "no id"), []