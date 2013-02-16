
define (require, exports) ->

  {success, warn} = require "./notify"

  exports.search = (key, call) ->
    $.post "/search", {key}, call

  exports.fetch = (data, call) ->
    item =
      id: data.id
    $.post "/fetch", item, call

  exports.auth = (password) ->
    $.post "/auth", {password}, (result) ->
      if result.auth
        success "Logined", "password saved"
      else
        warn "Failed to login", "please login later"

  exports