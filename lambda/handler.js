'use strict';

let pgp = require('pg-promise')();

const config = {
  user: 'root', //env var: PGUSER
  database: 'skyline_zalando', //env var: PGDATABASE
  password: '#P(*fhq3j(F#$:fo4pojf34fwe))', //env var: PGPASSWORD
  host: 'skyline-zalando.cycadpn5lmbi.eu-central-1.rds.amazonaws.com', // Server hosting the postgres database
  port: 5432, //env var: PGPORT
  max: 10, // max number of clients in the pool
  idleTimeoutMillis: 30000, // how long a client is allowed to remain idle before being closed
};

module.exports.hello = (event, context, callback) => {

  // create table items (
  //    id             INT PRIMARY KEY     NOT NULL,
  //    gender         INT     NOT NULL,
  //    color          INT     NOT NULL,
  //    brand          INT     NOT NULL,
  //    season         INT     NOT NULL
  // );

  let db = pgp(config);

  let handleError = (err) => {
    console.log(err);
    callback(err);
  };

  let closeConnection = () => {
    return pgp.end();
  };

  let handleSuccess = (res) => {
    console.log(res);
    callback(null, {
      statusCode: 200,
      body: JSON.stringify(res),
    });
  };

  let getSkyline = (item) => {
    console.log(item[0]);
    return db.query('select id, gender, color from items where gender = ${gender}', item[0]);
  };

  let getItem = (itemId) => {
    return db.query('select id, gender, color from items where id = ${id}', {id: itemId});
  };

  getItem(event.path.id)
    .then(getSkyline)
    .then(closeConnection)
    .then(handleSuccess)
    .catch(handleError);
};
