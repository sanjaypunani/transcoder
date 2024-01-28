const config = require("./config.js");
const fs = require("fs");
const _ = require("lodash");
const request = require("request");
const fetch = require("node-fetch");
const https = require("https");
const http = require("http");
const axios = require("axios");

const transcode = require("./transcode");

const { makeDb } = require("mysql-async-simple");
const mysql = require("mysql");

// function transJob(dbItem, cb) {
//     if (!dbItem.mediaFile) {
//         console.log("mediaFile Not Found")
//         updateStatus(dbItem, 'NOTFOUND', {}, cb);
//     } else {
//         let fileurl = dbItem.mediaFile.url;
//         let fname = dbItem.id;
//         let destination = "videos/" + fname + dbItem.mediaFile.ext;
//         console.log("Worker recived dbObject : ", fileurl);
//
//
//         updateStatus(dbItem, 'Transcoding', {});
//         downloadFile(fileurl, destination, m => {
//             if (m) {
//                 console.log("m is :", m)
//             }
//
//             transcode.transcode(dbItem, destination, (err, resp) => {
//                 if (err) {
//                     console.log("Something bad happened : ", err);
//                 }
//                 // console.log("M is : ", m)
//                 endTask(dbItem, resp, cb)
//             })
//         })
//     }
//
// }

function transJob(dbItem, cb) {
  if (!dbItem.video_location) {
    console.log("mediaFile Not Found");
    updateStatus(dbItem, "NOTFOUND", {}, cb);
  } else {
    // let fileurl = "/Users/varun/Projects/gnx/vidclick/server/public" + dbItem.video_location;
    let fileurl = config.fileDownloadPrefix + dbItem.video_location;

    // let fileurl = "/Users/varun/Projects/gnx/clickhere/video-script/server/public" + dbItem.video_location;
    let fname = dbItem.custom_url;
    let ext = dbItem.video_location.split(".").pop();
    let destination = "videos/" + fname + "." + ext;
    console.log("Worker recived dbObject : ", fileurl);

    console.log("fileurl : ", fileurl);
    updateTranscodingStatus(dbItem);
    updateStatus(dbItem, "Transcoding", {});
    downloadFile(fileurl, destination, (m) => {
      if (m) {
        console.log("m is :", m);
      }

      transcode.transcode(dbItem, destination, (err, resp) => {
        if (err) {
          console.log("Something bad happened : ", err);
        }
        // console.log("M is : ", m)
        // endTask(dbItem, resp, cb)
        sqlComplete(dbItem, cb);
        deleteFileFromMainServer(dbItem);
      });
    });
  }
}

function deleteFileFromMainServer(dbItem) {
  const requestOptions = {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ video_id: dbItem.custom_url }),
  };
  const deleteFileApi =
    config.fileDownloadPrefix + "/api/video/remove-video-file";
  console.log("deleteFileApi: ", deleteFileApi);
  fetch(deleteFileApi, requestOptions)
    .then((response) => response.json())
    .then((data) => {
      console.log("Server Response On Remove File:", data);
    });
}

function endTask(dbItem, resp, cb) {
  // console.log("response of Transcode is : ", resp)
  let url = config.urlPrefix + dbItem.id + "/" + dbItem.id + ".m3u8";
  updateStatus(dbItem, "Transcoded", { urlTranscodedFile: url }, cb);
}

async function sqlComplete(dbItem, cb) {
  // Update videos set completed = 1 where custom_url = 'vaiakmo1iicw'

  console.log("Running SQL Complete");

  // const connection = mysql.createConnection({
  //     host: "192.168.1.2",
  //     user: "varun",
  //     password: "123456",
  //     database: "vid1"
  // });

  const connection = mysql.createConnection(config.mysql);

  const db = makeDb();

  console.log("DB Made");

  await db.connect(connection);

  console.log("DB connected");

  try {
    let sql =
      "Update videos set completed = 1, transcoding = 0, status = 1  where custom_url = '" +
      dbItem.custom_url +
      "'";
    const rows = await db.query(connection, sql);

    console.log("Rows are updated ");
    // return rows;
    typeof cb === "function" && cb();
  } catch (e) {
    // handle exception
    console.log("Error happened ", e);
    typeof cb === "function" && cb();
  } finally {
    await db.close(connection);
  }
}

async function updateTranscodingStatus(dbItem) {
  const connection = mysql.createConnection(config.mysql);

  const db = makeDb();

  console.log("DB Made");

  await db.connect(connection);

  console.log("DB connected");

  try {
    let sql =
      `Update videos set transcoding = 1  where custom_url = '` +
      dbItem.custom_url +
      "'";
    const rows = await db.query(connection, sql);
    console.log("Transcoding status Updates are updated ");
    // return rows;
  } catch (e) {
    // handle exception
    console.log("Error happened ", e);
  } finally {
    await db.close(connection);
  }
}

function updateStatus(dbItem, status, data, cb) {
  let dt = {
    status,
  };
  if (data) {
    dt = {
      status: status,
      ...data,
    };
  }
  typeof cb === "function" && cb();
  //     axios.put(config.transApi + '/' + dbItem.id, dt)
  //         .then(response => {
  //             // console.log("responce is : ", response);
  //             console.log("Status [", status, "] Updated for ", dbItem.id);
  //             typeof cb === "function" && cb()
  //         })
  //         .catch(error => {
  //             console.log("Final Error", error);
  //             typeof cb === "function" && cb()
  //         });
}

function downloadFile(url, destination, cb) {
  // fs.createReadStream(url).pipe(fs.createWriteStream(destination));
  //
  // cb();

  let h = http;
  if (url.indexOf("https") >= 0) h = https;

  let file = fs.createWriteStream(destination);

  let request = h
    .get(url, function (response) {
      response.pipe(file);
      file.on("finish", function () {
        // console.log("File Downloaded ");
        file.close(cb);
      });
    })
    .on("error", function (err) {
      fs.unlink(destination);
      console.log("downloading " + url + " error " + err);
      if (cb) cb(err.message);
    });
}

module.exports = {
  transJob,
};
