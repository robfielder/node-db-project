# A Database Project Structure for Working With Postgres

I like working with Postgres, but I find database tooling to be a bit... lacking. So I created a "database project" structure to help me do the things I need. Specifically:

 - Unit Testing
 - Versioning
 - Compilation
 - Installation

Most developers, when they think of working with databases directly (writing functions, triggers, etc) cringe at the idea because *logic in database bad*. When you ask why, they mumble responses about testing and versioning.

It's not hard to handle these problems gracefully - that's what this project is all about. Write your SQL, execute your tests, watch your database grow. Use git to version your SQL files, change as needed.

After you've deployed, rev your version in `package.json` and create your change scripts. Write more tests! Change some more and get it right. When you're done: *deploy*.

## Authentication Data Routines, All For Postgres

Included in this project is a full authentication system by way of example, and also a nice Use Case. Use it to see how you can flex Postgres' powerful functions to make your life easier.

Do you ever grow tired of rewriting authentication routines? Registration, authentication - yes there are libraries that do this for you (Devise etc) but when you decide to upgrade/change platforms you have some problems to solve.

Is Devise compatible with your version of Rails? Is the built-in ASP.NET Membership stuff (OWIN etc) easy to use and updatable for when you need custom functionality? Do you like GUIDs? Can you optimize for full-text indexing?

Control. You should have it.

These libraries often do 80% of what you need, but after a few years you realize they don't capture (or don't do) *everything* you need, and you don't have the data that you want, or the audit trail you expect.

I say - let the database do what it's good at. Operations such as register and authenticate should be transactional, with full logging and part of their own namespace within Postgres.

User IDs should be sortable by time, easily indexable and ready to scale (beyond the default integer limit). Token authentication, OAuth-ready - it's all here.

## Installation

Download this repo, or fork/clone and install the node bits:

```sh
git clone https://github.com/robconery/pg_auth
cd pg_auth && npm install
```

Next, in the `env` directory, set up where your database will live. This is a *database project*, built to scale out as you need. 

This project uses [Massive](https://github.com/robconery/massive-js), so the settings you need to set correspond directly to Massive's settings.

For instance, to use a local database:

```js
{
	db : "pg-auth"
}
```

Or, for a remote:

```js
{
	connectionString: "postgresql://user:password@remoteserver.com:5678/pg-auth"
}
```

To install, simply run:

```sh
node index install
```

This will use your development settings (in `env/development/config.json`) and run the baseline SQL (version 1.0.0).

When you're ready to make changes to your database, simply rev the version in `package.json` (to 1.0.1, eg) and then create a directory for your changes in `sql/1-0-1`.

You can now add your change scripts to the `1-0-1` directory (be sure they're .sql files) and add your tests as you see fit. If you add tables, be sure to add a foreign key with `CASCADE DELETE` if they are foreign-keyed to the users table. If they aren't, you'll have to add drop scripts as appropriate.

## The Builds

Every time you run your tests, a new sql file is created that reflects the version of your project. So, the initial tests build version `1.0.0` and put it in `build/1-0-0.sql`. You can take this file and execute it wherever you like, or you can:

```sh
NODE_ENV=production node index install
```

This will reach out to your production DB and execute the scripts.

**WARNING:** the `1.0.0.sql` file drops the entire schema, so if you run this in production bad things can happen.


## Screencast

I built this project for a thing I'm working on (and very much needed) - and I screencasted my efforts. You can see how all of this was put together [over at Pluralsight](http://www.pluralsight.com/author/rob-conery).
