import express from "express";
import { upload } from "../config/multer_config.js";
const router = express.Router();
import authMiddleware from "../middleware/authMiddleware.js";
import ProfileController from "../controllers/profileController.js";

router.patch("/:id", [
  authMiddleware,
  upload.single("profile_pic"),
  ProfileController.update,
]);

export default router;
