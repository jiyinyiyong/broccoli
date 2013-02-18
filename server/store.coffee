
db = require("mongo-lite").connect "mongodb://localhost:27017/broccoli"
db.log = null

index = db.collection "index"
content = db.collection "content"

log = console.log

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

exports.create = (data, call) ->
  index_data =
    id: data.id
    title: data.title
    tags: data.tags
  content_data =
    id: data.id
    content: data.content
    time: make.time()

  index.insert index_data, (err1, doc1) ->
    content.insert content_data, (err2, doc2) ->
      call err2, doc2 if call?

exports.update = (data, call) ->
  # log "update", data
  index_data =
    id: data.id
    title: data.title
    tags: data.tags
  content_data =
    id: data.id
    content: data.content
    time: make.time()
  query = id: data.id

  index.update query, index_data, upsert: yes, (err1, doc1) ->
    content.update query, content_data, upsert: yes, (err2, doc2) ->
      call err2, doc2 is call?

exports.get_index = (call) ->
  index.all {}, {_id: 0}, (err, docs) -> call docs

exports.fetch = (data, call) ->
  query =
    id: data.id
  # log "doing fetch"
  content.first query, (err, docs) ->
    # log "fetched docs:", docs
    call docs

exports.remove = (data, call) ->
  query =
    id: data.id
  index.remove query, (err, docs) ->
    content.remove query, (err2, docs2) ->
      call()

exports.one = (query, call) ->
  index.first query, (err, data) ->
    if data?
      content.first query, (err, json) ->
        if json
          # log data, json, err
          data.time = json.time
          data.content = json.content
          call data
        else call null
    else call null