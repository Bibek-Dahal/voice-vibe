import Notification from "../models/notification.js";

class NotificationController {
  static listNotification = async (req, res) => {
    try {
      const notifications = await Notification.find({
        profile: req.profile_id,
      });
      res.status(200).send({
        data: notifications,
        message: "notification fetched",
        success: true,
      });
    } catch (error) {
      console.log(error);
      res.status(500).send({
        errors: {
          details: ["something went wrong"],
        },
        success: false,
      });
    }
  };

  static retriveNotification = async (req, res) => {
    const { id } = req.params;
    try {
      let notification = await Notification.findOne({
        _id: id,
        profile: req.profile_id,
      });

      if (notification.is_seen == false) {
        notification = await Notification.findByIdAndUpdate(
          id,
          { is_seen: true },
          { returnDocument: "after" }
        );
        console.log(notification);
      }
      res.status(200).send({
        data: notification,
        message: "notification fetched",
        success: true,
      });
    } catch (error) {
      console.log(error);
      res.status(500).send({
        errors: {
          details: ["something went wrong"],
        },
        success: false,
      });
    }
  };
}

export default NotificationController;
