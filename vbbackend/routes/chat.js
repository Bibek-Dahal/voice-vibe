import express from "express";
import authMiddleware from "../middleware/auth_middleware.js";
import ChatController from "../controllers/chat_controller.js";
const router = express.Router();

router.get("/:id", [authMiddleware, ChatController.listChats]);

export default router;
