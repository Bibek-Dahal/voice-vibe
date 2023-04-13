import Joi from "joi";
import User from "../../models/user.js";
import showValidationsError from "../../utils/showValidationsError.js";
const pswdPtrn =
  /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!#%*?&]{6,20}$/;

const userLookup = async (email, helpers) => {
  let user;
  try {
    console.log("inside userlookup");
    user = await User.findOne({ email: email });
    console.log(user);
    if (user) {
      // console.log(helpers)
      console.log("email already exists");
      return helpers.message("email already exists");
    }
    console.log("hello babs");
    return email;
  } catch (error) {
    console.log(error);
  }
};

class AuthValidation {
  /*
        validation for registration
    */
  static async register(req, res, next) {
    const schema = Joi.object({
      username: Joi.string().trim().alphanum().min(3).max(50).required(),

      email: Joi.string()
        .trim()
        .email()

        .required(),

      phone_num: Joi.string().required(),

      password: Joi.string()
        .trim()
        .pattern(new RegExp(pswdPtrn))
        .required()
        .messages({
          "string.pattern.base":
            "password must contain atleast one digit one special character and one uppre case letter",
        }),

      repeat_password: Joi.any()
        .valid(Joi.ref("password"))
        .required()
        .messages({
          "any.only": "password and repeat password do not match",
          "any.required": "{{#label}} is required",
        }),
    });

    await showValidationsError(req, res, next, schema);
  }

  static async verifyOtp(req, res, next) {
    const validStrings = ["user_verification", "password_reset"];
    const schema = Joi.object({
      phone_num: Joi.string().required(),
      otp_credential: Joi.string().required(),
      otp: Joi.number().required(),
      verification_type: Joi.string()
        .valid(...validStrings)
        .required(),
    });

    showValidationsError(req, res, next, schema);
  }

  static async resendOtp(req, res, next) {
    const schema = Joi.object({
      phone_num: Joi.string().required(),
    });

    showValidationsError(req, res, next, schema);
  }
  static login(req, res, next) {
    const schema = Joi.object({
      phone_num: Joi.string().trim().required(),

      password: Joi.string().trim().required(),
    });

    showValidationsError(req, res, next, schema);
  }

  static passwordChange(req, res, next) {
    const schema = Joi.object({
      old_password: Joi.string().trim().required(),

      new_password: Joi.string()
        .trim()
        .pattern(new RegExp(pswdPtrn))
        .required()
        .messages({
          "string.pattern.base":
            "password must contain atleast one digit one special character and one uppre case letter",
        }),

      repeat_password: Joi.any()
        .valid(Joi.ref("new_password"))
        .required()
        .messages({
          "any.only": "password and repeat password do not match",
          "any.required": "{{#label}} is required",
        }),
    });

    showValidationsError(req, res, next, schema);
  }

  

  static passwordReset(req, res, next) {
    const schema = Joi.object({
      new_password: Joi.string()
        .trim()
        .pattern(new RegExp(pswdPtrn))
        .required()
        .messages({
          "string.pattern.base":
            "password must contain atleast one digit one special character and one uppre case letter",
        }),

      repeat_password: Joi.any()
        .valid(Joi.ref("new_password"))
        .required()
        .messages({
          "any.only": "password and repeat password do not match",
          "any.required": "{{#label}} is required",
        }),
      phone_num: Joi.string().required(),
    });

    showValidationsError(req, res, next, schema);
  }

  /*
            Group Controller Validations
        */
  static findUserByEmail(req, res, next) {
    const schema = Joi.object({
      email: Joi.string().required(),
    });

    showValidationsError(req, res, next, schema);
  }
}

export default AuthValidation;
