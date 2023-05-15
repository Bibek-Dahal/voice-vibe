import express from "express";
import authMiddleware from "../middleware/auth_middleware.js";
import ChatController from "../controllers/chat_controller.js";
const router = express.Router();

router.get("/:id([a-zA-Z0-9]{24})", [authMiddleware, ChatController.listChats]);

//display list of chats with users just like messaging app
router.get("/display-chat-associated-with-user", [
  authMiddleware,
  ChatController.displayChatAssociatedWithUser,
]);

export default router;
