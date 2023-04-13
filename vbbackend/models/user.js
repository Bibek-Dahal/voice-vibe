import mongoose from "mongoose";
import uniqueValidator from "mongoose-unique-validator";
import bcrypt from "bcrypt";
const saltRounds = 10;
import Profile from "./profile.js";

const userSchema = mongoose.Schema(
  {
    username: {
      type: String,
      trim: true,
      unique: true,
    },

    email: {
      type: String,
      unique: true,
      trim: true,
    },
    phone_num: {
      type: String,
      unique: true,
    },
    fcm_token: {
      type: Array,
    },

    password: {
      type: String,
    },

    is_phn_verified: {
      type: Boolean,
      default: false,
    },
    is_email_verified: {
      type: Boolean,
      default: false,
    },

    //determines whether user is verified or not
  }, //ends schema defn

  {
    timestamps: {
      createdAt: "created_at",
      updatedAt: "updated_at",
    },

    toJSON: { virtuals: true }, // So `res.json()` and other `JSON.stringify()` functions include virtuals
    toObject: { virtuals: true }, // So `console.log()` and other functions that use `toObject()` include virtuals
  }
);

// Specifying a virtual with a `ref` property is how you enable virtual
// population
// userSchema.virtual("group", {
//   ref: "Group",
//   localField: "_id",
//   foreignField: "user",
// });

userSchema.plugin(uniqueValidator, {
  message: "user with {PATH} already exists.",
});

//function for comparing password

userSchema.statics.checkUser = async function (plaintext, hashedText) {
  // console.log('hello static method called')
  // console.log(hashedText)
  const match = await bcrypt.compare(plaintext, hashedText);
  return match;
};

///function for hashing password which is called aftre validation
userSchema.pre("save", function (next) {
  let user = this;

  // only hash the password if it has been modified (or is new)
  if (!user.isModified("password")) return next();

  // hash the password using our new salt
  bcrypt.hash(user.password, saltRounds, function (err, hash) {
    if (err) return next(err);

    // override the cleartext password with the hashed one
    user.password = hash;
    next();
  });
});

userSchema.post("save", async (doc, next) => {
  // setTimeout(function () {
  //   console.log("post1");
  //   // Kick off the second post hook
  //   next();
  // }, 10);

  console.log("post save called", doc);
  try {
    const profile = Profile({ user: doc._id, profile_pic: null });
    await profile.save();
    console.log("profile created successfully");
    next();
  } catch (error) {
    next(error);
  }
  next();
});

userSchema.virtual("profile", {
  ref: "Profile",
  localField: "_id",
  foreignField: "user",
});

const User = mongoose.model("User", userSchema);
export default User;
