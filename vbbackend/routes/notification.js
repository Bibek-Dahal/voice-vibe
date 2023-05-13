import express from "express";
import authMiddleware from "../middleware/auth_middleware.js";
import NotificationController from "../controllers/notification_controller.js";
const router = express.Router();

//retrive notification
router.get("/:id", [
  authMiddleware,
  NotificationController.retriveNotification,
]);

//list notifications
router.get("", [authMiddleware, NotificationController.listNotification]);

export default router;
