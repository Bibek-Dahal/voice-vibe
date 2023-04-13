import mongoose from "mongoose";
const { Schema } = mongoose;
import uniqueValidator from "mongoose-unique-validator";

const topicSchema = new Schema({
  title: {
    type: String,
    unique: true,
  },
});

topicSchema.plugin(uniqueValidator, {
  message: "topic with {PATH} address already exists.",
});

const Topics = mongoose.model("User", topicSchema);
export default Topics;
