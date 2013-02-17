// Generated by CoffeeScript 1.4.0

define(function(require, exports) {
  var password, popup, success, warn, _ref;
  _ref = require("./notify"), success = _ref.success, warn = _ref.warn;
  popup = require("./popup");
  exports.search = function(key, call) {
    return $.post("/search", {
      key: key
    }, call);
  };
  exports.fetch = function(data, call) {
    return $.post("/fetch", {
      id: data.id
    }, call);
  };
  exports.auth = function(password) {
    return $.post("/auth", {
      password: password
    }, function(result) {
      if (result.auth) {
        success("Logined", "password saved");
        popup.hide();
        return $("#login").slideUp();
      } else {
        return warn("Failed to login", "please login later");
      }
    });
  };
  password = (localStorage.getItem("password")) || "";
  if (password.length > 6) {
    exports.auth(password);
  }
  exports.create = function(data, call) {
    data.password = password;
    return $.post("/create", data, call);
  };
  exports.remove = function(data, call) {
    data.password = password;
    return $.post("/remove", data, call);
  };
  return exports;
});
