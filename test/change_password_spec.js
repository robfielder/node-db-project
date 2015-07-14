var assert = require("assert");
var Helpers = require("./helpers");
var helpers = new Helpers();

describe('Changing a password', function(){
  var db=null;
  before(function(){
    db = helpers.initDb();
  });
  describe('with a valid old password', function(){
    var changeResult=null;
    before(function(done){
      db.membership.change_password(['test2@test.com','password','new-password'], function(err,res){
        assert(err===null,err);
        changeResult=res;
        done();
      });
    });
    it('changes and returns the user', function(){
      //if we get a record back, it worked
      assert(changeResult);
    });  
  });
});
