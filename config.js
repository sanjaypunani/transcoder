/**
 * Config Values
 */
// let apiDomai = 'http://localhost:1337/';
let apiDomai = "https://transcodingapi.html5.run/";

module.exports = {
  destiObjStorage: "",
  sourceObjStorage: "",

  transfer: "/tranodingScripts/transfer.sh",
  // urlPrefix: "https://storage.googleapis.com/ottflatfiles/",
  // urlPrefix: "https://storage.googleapis.com/indiaotthls/",
  urlPrefix: "https://indiaotthls.s3.ap-south-1.amazonaws.com/",

  transApi: apiDomai + "media-files",

  mysql: {
    host: "localhost",
    user: "root",
    password: "password",
    database: "vid129july",
    port: "3306",
  },

  // https://click.html5.run/upload/videos/video/1619254409143_g_.webm
  // fileDownloadPrefix: "/Users/varun/Projects/gnx/vidclick/server/public",
  //   fileDownloadPrefix: "https://upgov.inqtube.com",
  fileDownloadPrefix: "http://localhost:3000",

  /// Transcoding Configs
  trans: [
    {
      width: 256,
      path: "/tranodingScripts/144p.sh",
    },
    {
      width: 426,
      path: "/tranodingScripts/240p.sh",
    },
    {
      width: 640,
      path: "/tranodingScripts/360p.sh",
    },
    {
      width: 852,
      path: "/tranodingScripts/480p.sh",
    },
    {
      width: 1280,
      path: "/tranodingScripts/720p.sh",
    },
    {
      width: 1920,
      path: "/tranodingScripts/1080p.sh",
    },
  ],

  dummy: [
    {
      status: "Uploaded",
      _id: "600de4af7702750440df6b02",
      qualities: null,
      mediaName: "TestFile",
      dateUploaded: "2021-01-24T06:30:00.000Z",
      published_at: "2021-01-24T21:28:24.290Z",
      createdAt: "2021-01-24T21:20:47.698Z",
      updatedAt: "2021-01-24T21:28:24.429Z",
      __v: 0,
      category: {
        _id: "600de47a7702750440df6b01",
        categoryName: "News",
        published_at: "2021-01-24T21:28:18.384Z",
        createdAt: "2021-01-24T21:19:54.126Z",
        updatedAt: "2021-01-24T21:28:18.486Z",
        __v: 0,
        id: "600de47a7702750440df6b01",
      },
      mediaFile: {
        _id: "600d394d9627f2927698d4a8",
        name: "1112_MP_5 MIN 25 KHABREIN_KHAN.mp4",
        alternativeText: "",
        caption: "",
        hash: "1112_MP_5_MIN_25_KHABREIN_KHAN_13c89a6e9a",
        ext: ".mp4",
        mime: "video/mp4",
        size: 133898.19,
        url: "https://storage.googleapis.com/ottflatfiles/1112_MP_5_MIN_25_KHABREIN_KHAN_13c89a6e9a/1112_MP_5_MIN_25_KHABREIN_KHAN_13c89a6e9a.mp4",
        provider: "google-cloud-storage",
        width: null,
        height: null,
        related: ["600de4af7702750440df6b02"],
        createdAt: "2021-01-24T09:09:33.790Z",
        updatedAt: "2021-01-24T21:20:47.779Z",
        __v: 0,
        id: "600d394d9627f2927698d4a8",
      },
      owner: {
        _id: "600cb5f570a9457a9f427874",
        username: null,
        firstname: "Varun",
        lastname: "Gupta",
        __v: 0,
        id: "600cb5f570a9457a9f427874",
      },
      id: "600de4af7702750440df6b02",
    },
  ],
};
