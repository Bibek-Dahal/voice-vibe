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
import topic from "./routes/topic.js";
import chat from "./routes/chat.js";
const { router, setQueues, replaceQueues, addQueue, removeQueue } =
  createBullBoard([new BullAdapter(space_notification_queue)]);

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
app.use("/api/topic", topic);
app.use("/api/chat", chat);

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
