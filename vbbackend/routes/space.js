import express from "express";
import authMiddleware from "../middleware/auth_middleware.js";
import SpaceValidation from "../middleware/validators/space.js";
import SpaceController from "../controllers/space_controller.js";
const router = express.Router();

router.post("/", [
  authMiddleware,
  SpaceValidation.create,
  SpaceController.create,
]);

router.patch("/:id([a-zA-Z0-9]{24})", [
  authMiddleware,
  SpaceValidation.update,
  SpaceController.update,
]);

export default router;
