var assert = require("assert");
var Helpers = require("./helpers");
var helpers = new Helpers();

describe('Changing roles', function(){
  var db=null;
  before(function(done){
    db = helpers.initDb();
    db.membership.register(['joe@test.com', 'password'], function(err,res){
      done();
    });
  });
  describe("Adding to admin", function(){
    var changeResult=null;
    before(function(done){
      db.membership.add_user_to_role(['joe@test.com', 10], function(err,res){
        changeResult=res[0];
        done();
      });
    });
    it("makes them an admin", function(){
      assert(changeResult.is_admin);
    });
  });
    describe("Removing from admin", function(){
      var changeResult=null;
      before(function(done){
        db.membership.remove_user_from_role(['joe@test.com', 10], function(err,res){
          changeResult=res[0];
          done();
        });
      });
      it("makes them an admin", function(){
        assert.equal(false,changeResult.is_admin);
      });
    });
});
