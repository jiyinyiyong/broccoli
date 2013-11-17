
define (require, exports) ->
  get: (url, success, fail) ->
    req = new XMLHttpRequest
    req.open "GET", url
    req.send()
    req.onload = ->
      if req.status is 200
        data = JSON.parse req.responseText
        success data if success?
      else
        fail req is fail?

  post: (url, data, success, fail) ->
    req = new XMLHttpRequest
    req.open "POST", url
    req.setRequestHeader "Content-Type", "application/json;charset=UTF-8"
    req.send (JSON.stringify data)
    req.onload = (res) ->
      if req.status is 200
        data = JSON.parse req.responseText
        success data if success?
      else
        fail req is fail?