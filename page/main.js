// Generated by CoffeeScript 1.4.0

define(function(require, exports) {
  var popup, search;
  $("body").keydown(function(e) {
    switch (e.keyCode) {
      case 27:
        return $("#popup").fadeOut();
    }
  });
  require("./search");
  popup = require("./popup");
  search = require("./search");
  $("#search").keydown(function(e) {
    var keys, _ref;
    if ((_ref = e.keyCode) === 13 || _ref === 32) {
      keys = popup.split_tags($(this).val());
      return search.search(keys);
    }
  });
  $("#login").click(function() {
    return popup.auth();
  });
  $("#create").click(function() {
    return popup.create();
  });
  $("#popup").click(function(e) {
    if (e.target.id === "popup") {
      return popup.hide();
    }
  });
  delay(400, function() {
    return search.search([]);
  });
  return exports;
});