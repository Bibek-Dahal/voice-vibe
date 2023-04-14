import Profile from "../models/profile.js";
import User from "../models/user.js";

const isOwner = async (req, res, id, model) => {
  try {
    const obj = await model.findById(id);
    if (obj && obj.id == req.user_id) {
      console.log(obj);
      return;
    } else {
      return res.status(452).send({
        errors: {
          details: ["forbiden"],
        },
      });
    }
  } catch (error) {
    return res.status(500).send({
      errors: {
        details: ["something went wrong"],
      },
    });
  }
};

export default isOwner;
