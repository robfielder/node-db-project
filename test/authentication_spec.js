var assert = require("assert");
var Helpers = require("./helpers");
var helpers = new Helpers();
var db=null;
var registeredUser=null;

describe('Authentication', function(){
  before(function(done){
    db = helpers.initDb();
    db.membership.register(['test2@test.com','password'], function(err,res2){
      registeredUser=res2[0];
      assert(err===null,err);
      done();
    });
  });

  describe('with a valid login', function(){
    var authResult=null;
    before(function(done){
      db.membership.authenticate(['test2@test.com','password','local'], function(err,res){
        assert(err===null,err);
        authResult = res[0];
        done();
      });
    });
    it('is successful', function(){
      assert(authResult.success);
    });
  });
  describe('with a valid token', function(){
    var authResult=null;
    before(function(done){
      db.membership.authenticate_by_token(registeredUser.authentication_token, function(err,res){
        assert(err===null,err);
        authResult = res[0];
        done();
      });
    });
    it('is successful', function(){
      assert(authResult.success);
    });
  });
  describe('invalid login', function(){
    var authResult = null;
    before(function(done){
      db.membership.authenticate(['test2@test.com','poop','local'], function(err,res){
        assert(err===null,err);
        authResult = res[0];
        done();
      });
    });
    it('is not successful', function(){
      assert.equal(false, authResult.success);
    });
  });
  describe('locked out', function(){
    var authResult=null;
    before(function(done){
      db.membership.register(['test3@test.com','password'], function(err,res){
        db.run('update membership.users set status_id=20 where id=$1',[res[0].new_id], function(err,res2){
          db.membership.authenticate(['test3@test.com','password','local'], function(err,res3){
            authResult=res3[0];
            done();
          });
        });
      });
    });
    it('will fail', function(){
      assert.equal(authResult.success, false);
    });
    it('states that user is locked out', function(){
      assert.equal(authResult.message, 'This user is currently locked out');
    });
  });

});
