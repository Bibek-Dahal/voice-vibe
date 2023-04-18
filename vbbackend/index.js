import express, { response } from "express";
import connectDb from "./config/database.js";
import bodyParser from "body-parser";
import dotenv from "dotenv";
import cors from "cors";
import Sms from "./utils/send_sms.js";
import auth from "./routes/auth.js";
import profile from "./routes/profile.js";
import user from "./routes/user.js";
import space from "./routes/space.js";
import io from "./websocket/websocket.js";

import { space_notification_queue } from "./utils/schedule_task.js";
import { BullAdapter } from "bull-board/bullAdapter.js";
import { createBullBoard } from "bull-board";
const { router, setQueues, replaceQueues, addQueue, removeQueue } =
  createBullBoard([new BullAdapter(space_notification_queue)]);

// import { applicationDefault } from "firebase-admin/app";
// import admin from "firebase-admin";
// import google from "google-auth-library";

// import key from "./credentials";

// admin.initializeApp({
//   credential: applicationDefault(),
// });

// function getAccessToken() {
//   return admin.credential
//     .applicationDefault()
//     .getAccessToken()
//     .then((accessToken) => {
//       return accessToken.access_token;
//     })
//     .catch((err) => {
//       console.error("Unable to get access token");
//       console.error(err);
//     });
// }

// admin.messaging().send({
//   token:
//     "dOSYnC8UQgqRmljGKIFdbM:APA91bFhp9Vjcnu8L2980QDEmlUgGvWKchqyk4ZJXYDgQLzAuD52TmK-otjxf2g0ztLMs3eZm_MW1NbyXJ_wrpui2zZjWSXj-zzi-yujH56Agv3NggS3yUrHPYp8H9TuqqSfY6KrJ819",
//   data: {
//     hello: "world",
//   },
//   // schedule: Date.now(),
//   notification: {
//     title: "hello",
//     body: "hello this is me bibek",
//   },
//   schedule: "Tue Apr 18 2023 19:10:10 GMT+0545",

//   // Set Android priority to "high"
//   android: {
//     priority: "high",
//   },

//   // Add APNS (Apple) config
//   apns: {
//     payload: {
//       aps: {
//         contentAvailable: true,
//       },
//     },
//     headers: {
//       "apns-push-type": "background",
//       "apns-priority": "5", // Must be `5` when `contentAvailable` is set to true.
//       "apns-topic": "io.flutter.plugins.firebase.messaging", // bundle identifier
//     },
//   },
// });

dotenv.config();
const base_dir = process.cwd();
export default base_dir;

const app = express();
// app.use(express.json());
// parse application/json
app.use(bodyParser.json());

app.use(cors());

// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }));

app.use("/admin/queues", router);

app.use("/api", auth); //handle auth routes
app.use("/api/profile", profile);
app.use("/api/user", user);
app.use("/api/space", space);

const port = 8000;
const uri = "mongodb://localhost:27017";
const options = {
  dbName: "voicevibe",
};

connectDb(uri, options);

// app.get("/", async (req, res) => {
//   Sms.sendOtp("+9779864996631", req, res);
//   res.send("hello world");
// });

const server = app.listen(port, () => {
  console.log(`listening on port:${port}`);
});

// import Topic from "./models/favourite_topic_category.js";
// Topic.create({ title: "Nala" });

export { server };

io.listen(server);
