
define (require, exports) ->

  config = require "./config"

  exports.success = (title, message) ->
    toastr.timeOut = config.success_timeOut
    toastr.error title, message

  exports.warn = (title, message) ->
    toastr.timeOut = config.warning_timeOut
    toastr.warning title, message

  exports.info = (title, message) ->
    toastr.timeOut = config.info_timeOut
    toastr.info title, message

  exports.error = (title, message) ->
    toastr.timeOut = config.error_timeOut
    toastr.error title, message

  exports