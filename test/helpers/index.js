var Massive = require("massive");
var fs = require("fs");
var path = require("path");
var dbConfig = require("epa").getEnvironment()._config;
//connect to the database
var db = Massive.loadSync(dbConfig);

var Helpers = function(){
  //load up the schema file and run it
  var builder = require("../../lib/builder");
  var sql = builder.readSql();
  this.initDb = function(){

    try{
      //drop all the user records
      //this will cascade to everything else
      //the only time this will fail is on very first run
      //otherwise the DB should always be there
      db.runSync("delete from membership.users");
    }catch(err){}
    
    //now load up whatever SQL we want to run
    db.runSync(sql);
    //return a new Massive instance
    return Massive.loadSync(dbConfig);
  };

};

module.exports = Helpers;
