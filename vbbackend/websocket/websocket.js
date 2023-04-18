import { Server } from "socket.io";

import Chat from "../models/chat.js";

const io = new Server({
  cors: {
    // origin: ["http://127.0.0.1:3000","http://localhost:3000"],
    origin: "*",
    // credentials: true
  },
});

io.use((socket, next) => {
  //   console.log(socket);
  const username = socket.handshake.headers.username;
  const userId = socket.handshake.headers.userid;
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
    const { sender, receiver, text, to } = data;
    const newChat = await Chat.create({
      sender: sender,
      receiver: receiver,
      text: text,
    });

    const populated_chat = await newChat.populate("receiver sender");

    const newprof = await populated_chat.populate(
      "receiver.user sender.user",
      "username profile_pic"
    );
    console.log(newprof);

    // console.log(newprof);
    io.to([to, socket.userId]).emit("private message", {
      chat: newChat,
    });
  });
  // ...
});

export default io;
