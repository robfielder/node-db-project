var assert = require("assert");
var Helpers = require("./helpers");
var helpers = new Helpers();

describe('Status changes', function(){
  var db=null;
  before(function(done){
    db = helpers.initDb();
    db.membership.register(['jill@test.com','password'], function(err,res){
      done();
    });
  });
  describe('Suspension', function(){
    var statResult=null;
    before(function(done){
      db.membership.suspend_user(['jill@test.com','Testing'], function(err,res){
        assert(err===null,err);
        statResult = res[0];
        done();
      });
    });
    it('suspends the user', function(){
      assert.equal(statResult.status, "Suspended");
    });
    it('they cannot login', function(){
      assert.equal(statResult.can_login,false); 
    });
  });
  describe('Locking out', function(){
    var statResult=null;
    before(function(done){
      db.membership.lock_user(['jill@test.com','Testing'], function(err,res){
        assert(err===null,err);
        statResult = res[0];
        done();
      });
    });
    it('Locks the user', function(){
      assert.equal(statResult.status, "Locked");
    });
    it('they cannot login', function(){
      assert.equal(statResult.can_login,false); 
    });
  });
  describe('Banning', function(){
    var statResult=null;
    before(function(done){
      db.membership.ban_user(['jill@test.com','Testing'], function(err,res){
        assert(err===null,err);
        statResult = res[0];
        done();
      });
    });
    it('Bans the user', function(){
      assert.equal(statResult.status, "Banned");
    });
    it('they cannot login', function(){
      assert.equal(statResult.can_login,false); 
    });
  });
  describe('Activation', function(){
    var statResult=null;
    before(function(done){
      db.membership.activate_user(['jill@test.com','Testing'], function(err,res){
        assert(err===null,err);
        statResult = res[0];
        done();
      });
    });
    it('Activates the user', function(){
      assert.equal(statResult.status, "Active");
    });
    it('they can login', function(){
      assert(statResult.can_login); 
    });
  });
});
