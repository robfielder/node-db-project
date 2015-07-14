var assert = require("assert");
var Helpers = require("./helpers");
var helpers = new Helpers();

describe('Profile', function(){
  var db=null;
  before(function(done){
    db =helpers.initDb();
    db.membership.register(['jack@test.com', 'password'], function(err,res){
      done();
    });
  });
  describe("updating first and last", function(){
    var changeResult=null;
    before(function(done){
      db.membership.update_user(['jack@test.com', 'First', 'Last', {twitter : "jackityjack"}], function(err,res){
        changeResult=res[0];
        done();
      });
    });
    it("sets the display name to First Last", function(){
      assert.equal("First Last", changeResult.display_name);
    });
    it("sets the profile twitter to jackityjack", function(){
      assert.equal("jackityjack", changeResult.profile.twitter);
    });
  });
});
