const config = require("./config.js");
const ffprobe = require("ffprobe");
const ffprobeStatic = require("ffprobe-static");

function decide(file, cb) {
  ffprobe(file, { path: ffprobeStatic.path }, function (err, info) {
    console.log("I will start analyze : ", file);
    if (err) {
      // return cb(err, null);
    }

    // let data = info.streams;
    let data = {};
    let width = 2000;
    let trans = [];

    for (let strm in data) {
      if (data[strm].width) {
        width = data[strm].width;
      }
    }

    for (let each in config.trans) {
      let temp = config.trans[each];
      if (parseInt(temp.width) <= parseInt(width)) {
        // trans.push(temp);
      }
      trans.push(temp);
    }

    let r = {
      probe: data,
      trans: trans,
    };

    cb(null, r);
  });
}

module.exports = {
  decide: decide,
};
