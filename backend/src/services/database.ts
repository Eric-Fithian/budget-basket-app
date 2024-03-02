// Import the pg-promise library and initialize it
const pgp = require('pg-promise')();

console.log('Connecting to database using url: ' + process.env.DATABASE_URL);
let db = pgp(process.env.DATABASE_URL);

/*
The database object above represents a connection to our database. However,
it isn't actually connected yet. The object is an abstraction of the connection.
When you run a query against db, it will automatically connect to the database
and release it when its finished.

This database object should be the only one in the application. We import
the file where we need to make queries.
*/

module.exports = db;
