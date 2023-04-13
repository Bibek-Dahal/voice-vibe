import express, { response } from "express";
import connectDb from "./config/database.js";
import bodyParser from "body-parser";
import dotenv from "dotenv";
import cors from "cors";
import Sms from "./utils/sendSms.js";
import auth from "./routes/auth.js";
import profile from "./routes/profile.js";
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

app.use("/api", auth); //handle auth routes
app.use("/api/profile", profile);

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
