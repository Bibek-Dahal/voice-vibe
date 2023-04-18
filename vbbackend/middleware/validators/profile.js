import Joi from "joi";
const list_pattern = /[a-zA-Z0-9]{24}/;
import showValidationsError from "../../utils/show_validations_error.js";

class ProfileValidation {
  static update = (req, res, next) => {
    const schema = Joi.object({
      //   user: Joi.string().required(),
      profile_pic: Joi.string(),
      folowers: Joi.array().items(
        Joi.string().pattern(new RegExp(list_pattern))
      ),
      following: Joi.array().items(
        Joi.string().pattern(new RegExp(list_pattern))
      ),
      favourite_topics: Joi.array().items(Joi.string()),
    });

    showValidationsError(req, res, next, schema);
  };

  static fetchProfileWithList = (req, res, next) => {
    const schema = Joi.object({
      user_list: Joi.array().items(
        Joi.string().pattern(new RegExp(list_pattern))
      ),
    });
    showValidationsError(req, res, next, schema);
  };
}

export default ProfileValidation;
