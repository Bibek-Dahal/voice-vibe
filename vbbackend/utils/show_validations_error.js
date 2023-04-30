import Joi from "joi";

//function for displaying error
const showValidationsError = async (req, res, next, schema) => {
  //if multipart request is used
  // if (req.body.favourite_topics) {
  //   req.body.favourite_topics = JSON.parse(req.body.favourite_topics);
  // }
  const { error, value } = await schema.validate(req.body, {
    abortEarly: false,
    errors: { label: "key" },
    wrap: { label: false },
  });
  if (!error) {
    next();
  } else {
    console.log(Joi.any);
    console.log(error.details);
    const err = error.details;

    let validationErrors = {};
    err.forEach((item) => {
      validationErrors[item.context.key] = item.message;
    });
    res.status(400).send({
      errors: { ...validationErrors },
      success: false,
    });
  }
};

export default showValidationsError;
