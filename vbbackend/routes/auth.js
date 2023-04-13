import express from "express";
const router = express.Router();

import UserController from "../controllers/userController.js";
import AuthValidation from "../middleware/validators/auth.js";
import authMiddleware from "../middleware/authMiddleware.js";

router.post("/register", [AuthValidation.register, UserController.register]);

router.post("/verify-otp", [
  AuthValidation.verifyOtp,
  UserController.verifyOtp,
]);

router.post("/send-otp", [AuthValidation.resendOtp, UserController.resendOtp]);

router.post("/login", [AuthValidation.login, UserController.login]);

router.post("/password-change", [
  authMiddleware,
  AuthValidation.passwordChange,
  UserController.passwordChange,
]);

router.post("/password-reset", [
  AuthValidation.passwordReset,
  UserController.passwordReset,
]);
export default router;
