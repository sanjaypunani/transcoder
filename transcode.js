let exec = require("child_process").execFile;

let config = require("./config.js");

let ffprobe = require("./analyze");

let async = require("async");

let path = require("path");
let getSize = require("get-folder-size");

let workingDirectory = __dirname;

async function transcode(dbItem, file, cb) {
  let filePath = workingDirectory + "/" + file;
  let sourceFolder = workingDirectory + "/videos";

  ffprobe.decide(file, function (err, resp) {
    if (err) {
      console.log("Got an error");
      return cb(err, null);
    }
    if (!resp) {
      console.log("Something is not right with data");
      return cb("FFprobe returned Null", null);
    }

    // console.log("The Responce of ffprobe is : ", resp, file);

    // let scripts = [];
    let scripts = resp.trans;
    // scripts = scripts.concat(resp.trans);
    scripts = scripts.concat([{ path: config.transfer }]);
    let env = {
      AWS_ACCESS_KEY_ID: "AKIAUQMRT3SWB6O7T674",
      AWS_SECRET_ACCESS_KEY: "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",
    };

    let options = {
      maxBuffer: 1024 * 2048,
      env: env,
    };

    console.log("Now i can execute ===================", scripts.length);
    async.eachSeries(
      scripts,
      function (a, c) {
        console.log(
          "EXECUTING==========> " +
            __dirname +
            " <=====> " +
            a.path +
            " <=====> " +
            file +
            " <=====> " +
            sourceFolder +
            " <=====> "
        );

        let child = exec(
          __dirname + a.path,
          [__dirname + "/" + file, sourceFolder],
          options,
          function (err, stdout, stderr) {
            if (err) {
              console.log(err);
              process.exit();
            }
            console.log("std is ", err, stdout, stderr);
            // if (a.get_counter) {
            //     endTseg = parseInt(stdout);
            // }
            // if (a.semi)
            //     cb(null, { ffprobe: r.data, startTS: startTSeg + 1, endTS: endTseg, options: options, out: options.env.out, relativeout: options.env.relativeout }, { semi: true });
            c();
          }
        );
      },
      function () {
        console.log("transcoding for " + file + " is now complete");
        /// returns with parameters to the callback funtion to function.js and after_trans
        getSize(sourceFolder + "/" + dbItem.id, function (err, size) {
          console.log("Folder size is : ", size);
          cb(null, { ffprobe: resp.probe, disk_size: size });
        });
      }
    );
  });
}

module.exports = {
  transcode: transcode,
};
