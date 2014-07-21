(function() {
  var boo, coo, foo, soo;

  foo = function() {
    return 'foo';
  };

  boo = function() {
    return foo();
  };

  soo = function() {
    return 'too';
  };

  coo = function() {
    return too();
  };

}).call(this);

//# sourceMappingURL=client.js.map
