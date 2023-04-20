import express from "express";
import authMiddleware from "../middleware/auth_middleware.js";
import TopicController from "../controllers/topic_controller.js";
const router = express.Router();

router.get("/", [authMiddleware, TopicController.getAllTopics]);
export default router;
