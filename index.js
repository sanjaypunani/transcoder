const fs = require("fs");
const _ = require("lodash");
const request = require("request");
const fetch = require("node-fetch");
const { makeDb } = require("mysql-async-simple");
const mysql = require("mysql");

require("console-stamp")(console, "[HH:MM:ss.l]");

const config = require("./config.js");

let fun = require("./functions");

console.log("Worker started : ", config.transApi);

process.env["NODE_TLS_REJECT_UNAUTHORIZED"] = "0";

async function getFetch(url) {
  try {
    const response = await fetch(url);
    const json = await response.json();
    return json;
  } catch (e) {
    console.log("fetch error : ", e);
  }
}

function sleep(ms) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
}

async function startWorker() {
  let url = config.transApi;
  // let jsn = await getFetch(url)
  let jsn = await sqlWorker();

  console.log(jsn);

  // find if something is requires transcoding or not
  let objs = [];
  jsn.forEach((obj) => {
    // if (obj.status === "Uploaded") {
    //     objs.push(obj)
    // }
    if (obj.completed === 0) {
      objs.push(obj);
    }
  });

  // Final decision making if we need to run the worker or not
  if (objs.length) {
    console.log("Needs to Transcode ", objs.length, " Files");
    let idx = 0;
    let asyncLoop = async (arr) => {
      console.log("Running for ", idx);
      fun.transJob(arr[idx], async () => {
        idx++;
        if (idx < arr.length) {
          asyncLoop(arr);
        } else {
          console.log("Nothing to be encoded");
          await sleep(15000);
          startWorker();
        }
      });
    };
    asyncLoop(objs);
  } else {
    console.log("Nothing waiting to be Transcoded");
    await sleep(15000);
    startWorker();
  }
  // setTimeout(startWorker, 15000);
}

async function sqlWorker() {
  // const connection = mysql.createConnection({
  //     host: "192.168.1.2",
  //     user: "varun",
  //     password: "123456",
  //     database: "vid1"
  // });

  const connection = mysql.createConnection(config.mysql);

  const db = makeDb();

  await db.connect(connection);

  try {
    let sql = "SELECT * FROM videos WHERE completed = 0 AND custom_url != '' ";
    const rows = await db.query(connection, sql);
    console.log("Rows are : ", rows);
    return rows;
  } catch (e) {
    // handle exception
  } finally {
    await db.close(connection);
  }

  // connection.connect( async function (err) {
  //     if (err) throw err;
  //     console.log("Connected!");
  //     let sql = "SELECT * FROM videos WHERE completed = 0";
  //     // await connection.query(sql, function (error, results, fields) {
  //     //     if (error) throw error;
  //     //     console.log('The result is: ', results);
  //     //     return results;
  //     // });
  //     let rows = await connection.query(sql)
  //     console.log("Rows are : ", rows);
  //     return rows;
  // });
}

// sqlWorker();

startWorker();
// fun.transJob(config.dummy[0])
