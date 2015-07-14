/// <reference path="typings/node/node.d.ts"/>
var program = require("commander");
var builder = require("./lib/builder");

program
  .command('build')
  .description('Build the SQL files for our project')
  .action(function(){
    console.log("Building now...");
    builder.readSql();
    console.log("File created");
  });

program
  .command('install')
  .description('Build the SQL files for our project')
  .action(function(){
    console.log("Installing");
    builder.install();
    console.log("done");
  });
program.parse(process.argv);

