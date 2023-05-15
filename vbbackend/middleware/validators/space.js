import Joi from "joi";
import showValidationsError from "../../utils/show_validations_error.js";
const list_pattern = /[a-zA-Z0-9]{24}/;

class SpaceValidation {
  static create = (req, res, next) => {
    const schema = Joi.object({
      title: Joi.string().required(),
      description: Joi.string(),
      space_topics: Joi.array().items(Joi.string()).required(),
      is_finished: Joi.bool().default(false),
      schedule_date: Joi.date().iso().required(),
    });
    showValidationsError(req, res, next, schema);
  };

  static update = (req, res, next) => {
    const schema = Joi.object({
      title: Joi.string(),
      description: Joi.string(),
      space_topics: Joi.array().items(Joi.string()),
      is_finished: Joi.bool(),
      is_live: Joi.bool(),
      schedule_date: Joi.date().iso(),
    });
    showValidationsError(req, res, next, schema);
  };
}

export default SpaceValidation;
