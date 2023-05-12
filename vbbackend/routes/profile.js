import express from "express";
import { upload } from "../config/multer_config.js";
const router = express.Router();
import authMiddleware from "../middleware/auth_middleware.js";
import ProfileController from "../controllers/profile_controller.js";
import ProfileValidation from "../middleware/validators/profile.js";
import Profile from "../models/profile.js";
//update profile
router.patch("/:id([a-zA-Z0-9]{24})", [
  authMiddleware,
  upload.single("profile_pic"),
  ProfileValidation.update,
  ProfileController.update,
]);

//retrive profile by id
router.get("/:id([a-zA-Z0-9]{24})", [
  authMiddleware,
  ProfileController.getProfileById,
]);

//retrive logged user profile
router.get("/", [authMiddleware, ProfileController.getProfile]);

//retrive all profile except own profile
router.get("/retrive-all-profile", [
  authMiddleware,
  ProfileController.retriveAllProfile,
]);

router.post(
  "/retrive-profile-with-list",
  authMiddleware,
  ProfileValidation.fetchProfileWithList,
  ProfileController.retriveProfileWithList
);

router.post("/follow/:id([a-zA-Z0-9]{24})", [
  authMiddleware,
  ProfileController.followProfile,
]);

router.post("/unfollow/:id([a-zA-Z0-9]{24})", [
  authMiddleware,
  ProfileController.unfollowProfile,
]);

export default router;
