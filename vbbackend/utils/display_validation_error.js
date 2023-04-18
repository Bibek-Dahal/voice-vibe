const displayValidationError = (err) => {
  let validationErrors = {};
  err.forEach((item) => {
    validationErrors[item.context.key] = item.message;
  });
  return {
    errors: { ...validationErrors },
    success: false,
  };
};

const displayMongooseValidationError = (req, res, error) => {
  // console.log('hello i am called')
  let err = {
    errors: {},
    success: "false",
  };
  if (error.name === "ValidationError") {
    Object.keys(error.errors).forEach((key) => {
      err.errors[key] = error.errors[key].message;
    });

    return res.status(400).send(err);
  } else {
    console.log(error);
    return res.status(500).send({ message: "Something went wrong" });
  }
};

export { displayValidationError, displayMongooseValidationError };
