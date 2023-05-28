import { Server } from "socket.io";

import Chat from "../models/chat.js";
import uploadFromBuffer from "../utils/upload_file.js";
import Profile from "../models/profile.js";
import mongoose from "mongoose";

let onlineUsers = [];
const io = new Server({
  cors: {
    // origin: ["http://127.0.0.1:3000","http://localhost:3000"],
    origin: "*",
    // credentials: true
  },
});

io.use((socket, next) => {
  // console.log(socket);
  console.log("hello");
  const username = socket.handshake.headers.username;
  const userId = socket.handshake.headers.userid;
  // console.log(socket.handshake.auth);

  // const username = socket.handshake.auth.username;
  // const userId = socket.handshake.auth.userid;

  if (!username) {
    return next(new Error("invalid username"));
  }
  socket.username = username;
  socket.userId = userId;
  next();
});

io.on("connection", async (socket) => {
  // console.log("connection called", socket);
  let users = [];
  console.log(socket.userId);

  //append new user to online user list msg will be sent to all except user

  //join user to room
  socket.join(socket.userId);

  users.push({
    userId: socket.userId,
    username: socket.username,
  });
  // notify existing users
  socket.broadcast.emit("user connected", {
    userId: socket.userId,
    username: socket.username,
  });

  // Create an array of promises
  const promises = Array.from(users).map(async (user) => {
    console.log("inside chatset foreach", Object.keys(user)[0]);
    const profilemodel = await Profile.findOne({
      _id: user.userId,
    })
      .populate({
        path: "user",
        select: "username",
        // populate: { path: "user", select: "email username" },
      })
      .select("profile_pic id");

    // const lastChat = c.slice(-1);
    let profileId = socket.userId;
    // Wait for all promises to resolve

    onlineUsers.push(profilemodel);
    // chatData = c;
  });

  await Promise.all(promises);
  console.log(onlineUsers);
  console.log(users);

  //basic emit to the sender
  io.emit("list online users", onlineUsers);

  //handle space connection
  socket.on("space live event", async (data) => {
    console.log("space live called", data);
    socket.join(data.space_id);
    socket.emit("space live event", "hello world");
  });

  //display list of online users
  socket.on("list online users", async (data) => {
    //retrive all the socket that are currently connected
    // for (let [id, socket] of io.of("/").sockets) {
    //   users.push({
    //     userId: socket.userId,
    //     username: socket.username,
    //   });
    // }

    //join socket to room

    // let onlineUsers = [];

    // // Create an array of promises
    // const promises = Array.from(users).map(async (user) => {
    //   console.log("inside chatset foreach", Object.keys(user)[0]);
    //   const profilemodel = await Profile.findOne({
    //     _id: user.userId,
    //   })
    //     .populate({
    //       path: "user",
    //       select: "username",
    //       // populate: { path: "user", select: "email username" },
    //     })
    //     .select("profile_pic id");

    //   // const lastChat = c.slice(-1);
    //   let profileId = socket.userId;
    //   // Wait for all promises to resolve

    //   console.log("profile model", profilemodel);
    //   onlineUsers.push(profilemodel);
    //   // chatData = c;
    // });

    // await Promise.all(promises);
    // console.log(onlineUsers);
    // console.log(users);
    // console.log();

    //basic emit to the sender
    io.emit("list online users", onlineUsers);
  });

  //join the room for private chatting
  socket.on("join private chat room", async (data) => {
    //join socket to room
    socket.join(socket.userId);

    //basic emit to the sender
    socket.emit("users", users);
  });

  //emitted when user send private message
  socket.on("private message", async (data) => {
    //user is already joined to room on its own id so socket.to(to) will send msg
    //to room where only single user exists
    // console.log("data", JSON.parse(data));
    data = JSON.parse(data);
    let cloudinaryRes;
    let { sender, receiver, text, to, message_type } = data;

    // if (message_type == "file" || message_type == "image") {

    //   //if not bs64encoded
    //   try {
    //     const response = await uploadFromBuffer(data.file);
    //     console.log(response);
    //     text = response.secure_url;
    //     console.log(text);
    //   } catch (error) {
    //     console.log(error);
    //     console.log("sorry cant upload file");
    //   }
    // }

    if (
      message_type == "file" ||
      message_type == "image" ||
      message_type == "audio"
    ) {
      console.log("Received audio data!");

      try {
        // decode the Base64 string to a buffer
        // console.log("file", data.file);
        const decodedAudio = Buffer.from(data.file, "base64");
        const response = await uploadFromBuffer(decodedAudio, "video");
        console.log("cloudinary res", response);
        cloudinaryRes = response;
        text = response.secure_url;
        console.log(text);
      } catch (error) {
        console.log(error);
        console.log("sorry cant upload file");
      }

      // decode the Base64 string to a buffer
      // const decodedAudio = Buffer.from(data.audio.split(",")[1], "base64");

      // save the buffer to a file
      // fs.writeFile("audio.mp3", decodedAudio, function (err) {
      //   if (err) throw err;
      //   console.log("Audio saved!");

      // });
    }
    const newChat = await Chat.create({
      sender: sender,
      receiver: receiver,
      text: text,
      message_type: message_type,
    });

    const populated_chat = await newChat.populate("receiver sender");

    console.log(populated_chat);

    const newprof = await populated_chat.populate(
      "receiver.user sender.user",
      "username profile_pic"
    );
    // console.log(newprof);

    // console.log(newprof);
    if (message_type == "audio") {
      io.to([to, socket.userId]).emit("private message", {
        chat: newprof,
        cloudinaryRes: { duration: cloudinaryRes.duration },
      });
    }
    io.to([to, socket.userId]).emit("private message", {
      chat: newprof,
    });
  });

  socket.on("disconnect", () => {
    console.log("socket disconnect called");
    console.log("previous length", onlineUsers.length);
    console.log(socket.userId);
    const filteredArray = onlineUsers.filter(
      (obj) => obj["_id"].toString() !== socket.userId
    );
    console.log("after length", filteredArray.length);
    onlineUsers = filteredArray;
    io.emit("list online users", filteredArray);
  });
  // ...
});

// io.on("connection", (socket) => {
//   console.log("connection called", socket);
//   // console.log(socket.handshake.headers);
//   let users = [];
// });

export default io;
