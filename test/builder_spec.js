var builder = require("../lib/builder");
var assert = require("assert");
var Helpers = require("./helpers");
var helper = new Helpers();

describe('SQL Builder', function(){
  before(function(){
    helper.initDb();
  });
  it("loads", function(){
    assert(builder);
  });
  describe('loading sql', function(){
    it('returns a sql string', function(){
      var sql = builder.readSql();
      assert(sql);
    });
  });
});
