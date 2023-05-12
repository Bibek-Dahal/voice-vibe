import { Server } from "socket.io";

import Chat from "../models/chat.js";
import uploadFromBuffer from "../utils/upload_file.js";
import fs from "fs";
const io = new Server({
  cors: {
    // origin: ["http://127.0.0.1:3000","http://localhost:3000"],
    origin: "*",
    // credentials: true
  },
});

io.use((socket, next) => {
  // console.log(socket);
  // const username = socket.handshake.headers.username;
  // const userId = socket.handshake.headers.userid;
  // console.log(socket.handshake.auth);

  const username = socket.handshake.auth.username;
  const userId = socket.handshake.auth.userid;

  if (!username) {
    return next(new Error("invalid username"));
  }
  socket.username = username;
  socket.userId = userId;
  next();
});

io.on("connection", (socket) => {
  console.log(socket.userId);
  const users = [];
  //retrive all the socket that are currently connected
  for (let [id, socket] of io.of("/").sockets) {
    users.push({
      userId: socket.userId,
      username: socket.username,
    });
  }

  //join socket to room
  socket.join(socket.userId);

  //basic emit to the sender
  socket.emit("users", users);

  //append new user to online user list msg will be sent to all except user

  // notify existing users
  socket.broadcast.emit("user connected", {
    userId: socket.userId,
    username: socket.username,
  });

  //emitted when user send private message
  socket.on("private message", async (data) => {
    //user is already joined to room on its own id so socket.to(to) will send msg
    //to room where only single user exists
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
        const decodedAudio = Buffer.from(data.file.split(",")[1], "base64");
        const response = await uploadFromBuffer(decodedAudio, "video");
        console.log(response);
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
    io.to([to, socket.userId]).emit("private message", {
      chat: newprof,
    });
  });
  // ...
});

export default io;
