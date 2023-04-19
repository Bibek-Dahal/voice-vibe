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

router.get("/:id([a-zA-Z0-9]{24})", [
  authMiddleware,
  SpaceController.retriveSpace,
]);

router.delete("/:id([a-zA-Z0-9]{24})", [
  authMiddleware,
  SpaceController.deleteSpace,
]);

router.get("/get-all-space", [authMiddleware, SpaceController.getAllSpace]);

export default router;
