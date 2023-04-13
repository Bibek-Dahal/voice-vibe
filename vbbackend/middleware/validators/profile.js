import Joi from "joi";
class ProfileValion {
  static update = (req, res, next) => {
    const schema = Joi.object({
      //   user: Joi.string().required(),
      profile_pic: Joi.string(),
      folowers: Joi.array().items(Joi.string()),
      following: Joi.array().items(Joi.string()),
      favourite_topics: Joi.array().items(Joi.string()),
    });

    showValidationsError(req, res, next, schema);
  };
}
