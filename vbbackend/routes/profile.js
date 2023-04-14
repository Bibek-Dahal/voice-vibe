import express from "express";
import { upload } from "../config/multer_config.js";
const router = express.Router();
import authMiddleware from "../middleware/authMiddleware.js";
import ProfileController from "../controllers/profileController.js";

router.patch("/:id([a-zA-Z0-9]{24})", [
  authMiddleware,
  upload.single("profile_pic"),
  ProfileController.update,
]);

router.get("/:id([a-zA-Z0-9]{24})", [
  authMiddleware,
  ProfileController.getProfileById,
]);

router.get("/", [authMiddleware, ProfileController.getProfile]);

export default router;
