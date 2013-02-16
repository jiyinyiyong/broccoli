// Generated by CoffeeScript 1.4.0

define(function(require, exports) {
  var ajax, card, popup, query, search, table, tags;
  ajax = require("./ajax");
  popup = require("./popup");
  search = $("#search").focus();
  table = $("#table");
  card = function(data) {
    return $(lilyturf.dom(function() {
      return this.div({
        "class": "card"
      }, this.div({
        "class": "title"
      }, this.text(data.title)), this.div({
        "class": ""
      }, this.text(data.title)));
    }));
  };
  query = function(key) {
    return ajax.search(key, function(list) {
      return log(list);
    });
  };
  tags = require("./config").tags;
  tags.forEach(function(tag) {
    var elem;
    elem = $(lilyturf.dom(function() {
      return this.div({
        "class": "tag"
      }, this.text(tag));
    }));
    $("#tags").append(elem);
    return elem.click(function() {
      return query(tag);
    });
  });
  return exports;
});
