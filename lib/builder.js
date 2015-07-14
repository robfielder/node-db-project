var fs = require("fs");
var path = require("path");
var _ = require("underscore")._;
var config = require("../package.json");
var dbConfig = require("epa").getEnvironment()._config;
var Massive = require("massive");

var versionRoot = config.version.replace(/\./g, "-");
var sourceDir = path.join(__dirname, "../sql/", versionRoot );

var loadFiles = function(dir){
  var glob = require("glob");
  var globPattern = path.join(sourceDir, "**/*.sql");

  // use nosort to ensure that init.sql is loaded first
  var files = glob.sync(globPattern, {nosort : true});
  var result = ['set search_path=membership;'];
  _.each(files, function(file){
    var sql = fs.readFileSync(file, {encoding : "utf-8"});
    result.push(sql);
  });
  return result.join("\r\n");
};


var decideSqlFile = function(){
  var buildDir = path.join(__dirname, "../build");
  var fileName = versionRoot + ".sql";
  return path.join(buildDir,fileName);
};

exports.readSql = function(){
  var sqlBits = loadFiles();
  //write it to file
  var sqlFile = decideSqlFile();
  fs.writeFileSync(sqlFile,sqlBits);
  return sqlBits;
};

exports.install = function(){
  var db = Massive.connectSync(dbConfig);
  var sqlFile = decideSqlFile();
  var sql = fs.readFileSync(sqlFile,{encoding : "utf-8"});
  return db.runSync(sql);
};
