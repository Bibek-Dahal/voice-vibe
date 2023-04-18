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
  message: "topic with {PATH} already exists.",
});

const Topic = mongoose.model("Topic", topicSchema);
export default Topic;
