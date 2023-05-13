import mongoose from "mongoose";
const { Schema } = mongoose;
import { scheduleTask } from "../utils/schedule_task.js";
import Topic from "./favourite_topic_category.js";
import { space_notification_queue } from "../utils/schedule_task.js";
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
    job_id: {
      type: String,
      default: "",
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

spaceSchema.pre("save", async function (next) {
  console.log("pre save called:");
  let space = this;
  console.log(this.isModified("schedule_date"));

  if (!this.isModified("schedule_date")) return next();
  console.log("document has been modified");
  try {
    const job = await space_notification_queue.getJob(this.job_id);
    console.log(job);
    if (job) {
      await job.remove();
    }

    const job_id = await scheduleTask(
      space.schedule_date,
      space.space_topics,
      space
    );
    console.log(job_id);
    this.job_id = job_id.id;
  } catch (error) {
    console.log(error);
  }

  next();
});

const Space = mongoose.model("Spaces", spaceSchema);
export default Space;
