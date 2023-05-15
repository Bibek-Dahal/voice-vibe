import Chat from "../models/chat.js";

class ChatController {
  static listChats = async (req, res) => {
    const { id } = req.params;
    try {
      console.log(req.profile_id);
      const chats = await Chat.find({
        sender: req.profile_id,
        receiver: id,
      })
        .populate({
          path: "sender",
          select: "profile_pic",
          populate: { path: "user", select: "email username" },
        })
        .populate({
          path: "receiver",
          select: "profile_pic",
          populate: { path: "user", select: "email username" },
        });
      if (chats) {
        res.status(200).send({
          message: "chat fetched successfully",
          data: chats,
          success: true,
        });
      } else {
        res.status(404).send({
          errors: {
            details: ["page not found"],
          },
          success: false,
        });
      }
    } catch (error) {
      console.log(error);

      res.status(500).send({
        errors: {
          details: ["something went wrong"],
        },
      });
    }
  };

  static displayChatAssociatedWithUser = async (req, res) => {
    try {
      console.log("profile id", req.profile_id);
      const chats = await Chat.find({
        $or: [{ sender: req.profile_id }, { receiver: req.profile_id }],
      });
      console.log(chats);
      const chatSet = new Set();
      chats.forEach((chat) => {
        //determinnes chats of user with other user
        if (chat.sender == req.profile_id) {
          console.log("inside if", chat.receiver.toString());
          chatSet.add(chat.receiver.toString());
        } else {
          console.log("inside else", chat.sender.toString());
          // console.log(chat.sender.toString());
          chatSet.add(chat.sender.toString());
        }
      });

      const chatData = [];

      // Create an array of promises
      const promises = Array.from(chatSet).map(async (id) => {
        console.log("inside chatset foreach");
        const c = await Chat.find({
          $or: [{ sender: id }, { receiver: id }],
        })
          .populate({
            path: "sender",
            select: "profile_pic",
            populate: { path: "user", select: "email username" },
          })
          .populate({
            path: "receiver",
            select: "profile_pic",
            populate: { path: "user", select: "email username" },
          })
          .sort({ created_at: -1 })
          .limit(1);

        const lastChat = c.slice(-1);

        // chatData.push(lastChat[0]);
        chatData.push(c);
      });

      // Wait for all promises to resolve
      await Promise.all(promises);

      console.log("chatdata", chatData);
      console.log(chatSet);

      res.status(200).send({
        data: chatData,
        message: "chat fetched successfully",
        success: true,
      });
    } catch (error) {
      console.log(error);

      res.status(500).send({
        errors: {
          details: ["something went wrong"],
        },
      });
    }
  };
}

export default ChatController;
