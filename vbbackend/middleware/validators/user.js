import Joi from "joi";

import showValidationsError from "../../utils/show_validations_error.js";

class UserValidation {
  static async update(req, res, next) {
    const schema = Joi.object({
      username: Joi.string().trim().alphanum().min(3).max(50),
      fcm_token: Joi.array().items(Joi.string()),
    });

    await showValidationsError(req, res, next, schema);
  }
}
export default UserValidation;
