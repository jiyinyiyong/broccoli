
define (require, exports) ->

  {success, warn, info, error} = require "./notify"
  popup = require "./popup"
  config = require "./config"

  exports.auth = (password) ->
    $.post "/auth", {password}, (result) ->
      if result.auth
        success "Logined", "password saved"
        popup.hide()
        $("#login").slideUp()
      else
        warn "Failed to login", "please login later"

  password = (localStorage.getItem "password") or ""
  if password.length > config.min_password
    exports.auth password

  exports.fetch = (data, call) ->
    data.password = password
    $.post "/fetch", data, call

  exports.remove = (data, call) ->
    data.password = password
    $.post "/remove", data, (result) ->
      if result.auth then success "Removed", ""
      else error "Failed", "maybe for password"

  exports.update = (data, call) ->
    data.password = password
    # log data
    unless data.title?.length > config.min_title
      error "No Title", "Can't post without title"
    else unless data.content?.length > config.min_content
      error "Bad article", "too few words here"
    else 
      $.post "/update", data, (result) ->
        if result.auth then success "Updated", "blog is ok"
        else error "Failed", "failed to update"

  exports.get_index = (call) ->
    $.getJSON "/get_index", (json) -> call json

  exports.remove = (data, call) ->
    data.password = password
    $.post "/remove", data, (result) ->
      if result.auth
        success "Got response", "Should be fine"
        call()
      else error "Failed", "need to login"

  exports