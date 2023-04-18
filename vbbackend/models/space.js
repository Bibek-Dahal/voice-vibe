import mongoose from "mongoose";
const { Schema } = mongoose;
import { scheduleTask } from "../utils/schedule_task.js";
import Topic from "./favourite_topic_category.js";
const spaceSchema = mongoose.Schema(
  {
    owner: {
      type: Schema.Types.ObjectId,
      ref: "Profile",
    },
    title: {
      type: String,
    },
    description: {
      type: String,
    },
    space_topics: [
      {
        type: String,
      },
    ],
    schedule_date: {
      type: Date,
    },
    is_finished: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: {
      createdAt: "created_at",
      updatedAt: "updated_at",
    },
  }
);

spaceSchema.post("save", async function (doc, next) {
  console.log("pre save called:");
  let space = this;
  // const topics = await Topic.find({ _id: { $in: [space.favourite_topics] } });
  // console.log(topics);
  // if (!space.isModified("schedule_date")) return next();
  // const topics = await space.populate("space_topics", "title");

  // // console.log(space);
  // console.log(topics);
  // const topics_title = topics.space_topics.map((topic) => topic.title);
  // console.log(topics_title);

  scheduleTask(space.schedule_date, space.space_topics);

  // if (!this.isModified(this.favourite_topics)) return next();

  // // only hash the password if it has been modified (or is new)
  // if (!user.isModified("password")) return next();

  // handleSubscription(
  //   prev_doc.favourite_topics,
  //   this.favourite_topics,
  //   this.user
  // );
  next();
});

const Space = mongoose.model("Spaces", spaceSchema);
export default Space;
