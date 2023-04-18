import mongoose from "mongoose";
const { Schema } = mongoose;

import { handleSubscription } from "../utils/handle_subscripton_topics.js";

const profileSchema = new Schema(
  {
    user: {
      type: Schema.Types.ObjectId,
      ref: "User",
    },
    profile_pic: { type: String, default: null },
    followers: [{ type: Schema.Types.ObjectId, ref: "User" }],
    following: [{ type: Schema.Types.ObjectId, ref: "User" }],
    favourite_topics: [],
  },
  {
    timestamps: {
      createdAt: "created_at",
      updatedAt: "updated_at",
    },
  }
);

profileSchema.pre("save", async function (next) {
  console.log("pre save called:", this._id);
  const prev_doc = await Profile.findById(this._id);

  if (prev_doc) {
    console.log("before", prev_doc.favourite_topics);
    console.log("this", this.favourite_topics);
    // if (!this.isModified(this.favourite_topics)) return next();

    // // only hash the password if it has been modified (or is new)
    // if (!user.isModified("password")) return next();

    // // hash the password using our new salt
    // bcrypt.hash(user.password, saltRounds, function (err, hash) {
    //   if (err) return next(err);

    //   // override the cleartext password with the hashed one
    //   user.password = hash;

    handleSubscription(
      prev_doc.favourite_topics,
      this.favourite_topics,
      this.user
    );
  }

  next();

  // });
});

const Profile = mongoose.model("Profile", profileSchema);
export default Profile;
