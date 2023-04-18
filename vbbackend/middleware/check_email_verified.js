import User from "../models/user.js";
const isEmailVerified = async (req, res, next) => {
  try {
    const user = await User.findById(req.user_id);
    if (user.is_email_verified) {
      next();
    } else {
      return res.status(452).send({
        message: "please verify your email",
        success: false,
      });
    }
  } catch (error) {
    console.log("user not found");
  }
};
