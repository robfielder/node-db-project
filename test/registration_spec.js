var assert = require("assert");
var Helpers = require("./helpers");
var helpers = new Helpers();

describe('Registration', function(){
  var db=null;
  before(function(){
    db =helpers.initDb();
  });
  describe('with valid creds', function(){
    var regResult=null;
    before(function(done){
      db.membership.register(['test1@test.com', 'password'], function(err,res){
        assert(err===null,err);
        regResult=res[0];
        done();
      });
    });
    it("is successful", function(){
      assert(regResult.success);
    });
    it('returns a new id', function(){
      assert(regResult.new_id);
    });
    it('returns a validation token', function(){
      assert(regResult.validation_token);
    });
    it('adds them to a role', function(done){
      db.run("select count(1) from membership.users_roles where user_id=$1",[regResult.new_id], function(err,res){
        assert.equal(res[0].count, 1);
        done();
      });
    });
  });
  describe('trying an existing user', function(){
    var regResult=null;
    before(function(done){
      db.membership.register(['test1@test.com', 'password'], function(err,res){
        regResult = res[0];
        done();
      });
    });
    it('is not successful', function(){
      assert.equal(false, regResult.success); 
    });
  });
});
