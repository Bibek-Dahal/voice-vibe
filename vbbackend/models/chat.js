import mongoose from "mongoose";
const { Schema } = mongoose;

const chatSchema = mongoose.Schema(
  {
    sender: {
      type: Schema.Types.ObjectId,
      ref: "Profile",
    },
    receiver: {
      type: Schema.Types.ObjectId,
      ref: "Profile",
    },
    text: {
      type: String,
    },
    message_type: {
      type: String,
    },
  },
  {
    timestamps: {
      createdAt: "created_at",
      updatedAt: "updated_at",
    },
  }
);

const Chat = mongoose.model("Chat", chatSchema);
export default Chat;
