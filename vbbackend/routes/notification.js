import express from "express";
import authMiddleware from "../middleware/auth_middleware.js";
import NotificationController from "../controllers/notification_controller.js";
const router = express.Router();

//count unseen notificatioin
router.get("/count", [
  authMiddleware,
  NotificationController.countUnseenNotificatioin,
]);

//retrive notification
router.get("/:id([a-zA-Z0-9]{24})", [
  authMiddleware,
  NotificationController.retriveNotification,
]);

//list notifications
router.get("", [authMiddleware, NotificationController.listNotification]);

export default router;
