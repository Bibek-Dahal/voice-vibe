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
}

export default ChatController;
