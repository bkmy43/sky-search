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

const SKYLINE_COLUMNS = ['gender', 'color'];

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
    // console.log(err);
    closeConnection()
      .then(() => callback(err));
  };

  let closeConnection = (res) => {
    return new Promise((resolve) => {
      pgp.end();
      resolve(res);
    });
  };

  let handleSuccess = (res) => {
    // console.log(res);
    callback(null, {
      statusCode: 200,
      body: {
        itemIds: res.map((item) => {return item.id}),
        items: res,
      },
    });
  };

  let checkIfNotSkyline = (srcItem, item1, item2) => {
    let col;
    for (col of SKYLINE_COLUMNS) {
      // console.log(Math.abs(item2[col] - item1[col]), srcItem[col]);
      // if (Math.abs(item2[col] - item1[col]) <= srcItem[col]) {
      // if (item2[col] <= item1[col]) {
      if (Math.abs(item2[col] - srcItem[col]) <= Math.abs(item1[col] - srcItem[col])) {
        return;
      }
    }
    item1.is_skyline = false;
    // if (
    //   item2.gender > item1.gender &&
    //   item2.color > item1.color &&
    //   true
    // ) {
    //   item1.is_skyline = false;
    // }
  };

  let iterateItems = (srcItem, items, item1) => {
    return new Promise(() => {
      items.map(checkIfNotSkyline.bind(null, srcItem, item1))
    });
  };

  let itemsGeneralPromise = (srcItem, items) => {
    items.map(iterateItems.bind(null, srcItem, items));
    return Promise.all(items);
  };

  let getSkyline = (srcItem) => {
    // console.log('source item', srcItem[0]);
    return db.query(`select id, ${SKYLINE_COLUMNS.join(',')}, true as is_skyline from items where id != \${id}`, {id: srcItem[0].id})
      .then(itemsGeneralPromise.bind(null, srcItem[0]));
  };

  let filterSkyline = (items) => {
    return items.filter((item) => {
      return item.is_skyline;
    });
  };

  let getItem = (itemId) => {
    return db.query(`select id, ${SKYLINE_COLUMNS.join(',')} from items where id = \${id}`, {id: itemId});
  };

  getItem(event.path.id)
    .then(getSkyline)
    .then(filterSkyline)
    .then(closeConnection)
    .then(handleSuccess)
    .catch(handleError);
};
