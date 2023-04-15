import express from "express";
import authMiddleware from "../middleware/authMiddleware.js";
import UserController from "../controllers/userController.js";
import UserValidation from "../middleware/validators/user.js";
const router = express.Router();

router.patch("/:id([a-zA-Z0-9]{24})", [
  authMiddleware,
  UserValidation.update,
  UserController.updateUser,
]);

router.get("/:id([a-zA-Z0-9]{24})", [
  authMiddleware,
  UserController.getUserById,
]);

router.get("/", [authMiddleware, UserController.getUser]);

router.get("/retrive-all-user", [
  authMiddleware,
  UserController.retriveAllUser,
]);
export default router;
