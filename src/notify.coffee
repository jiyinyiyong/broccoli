
define (require, exports) ->

  exports.success = (title, message) ->
    toastr.timeOut = 2000
    toastr.error title, message

  exports.warn = (title, message) ->
    toastr.timeOut = 3000
    toastr.warning title, message

  exports.info = (title, message) ->
    toastr.timeOut = 3000
    toastr.warn title, message

  exports.error = (title, message) ->
    toastr.timeOut = 5000
    toastr.warn title, message

  exports