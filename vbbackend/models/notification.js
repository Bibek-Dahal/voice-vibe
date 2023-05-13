import mongoose from "mongoose";
const { Schema } = mongoose;

const notificationSchema = new Schema({
  profile: {
    type: Schema.Types.ObjectId,
    ref: "Profile",
  },
  title: {
    type: String,
  },
  body: {
    type: String,
  },
  space_id: {
    type: String,
  },
  is_seen: {
    type: Boolean,
    default: false,
  },
  created_at: {
    type: Date,
    default: Date.now(),
  },
});

const Notification = mongoose.model("Notification", notificationSchema);
export default Notification;
