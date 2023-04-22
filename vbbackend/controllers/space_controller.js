import Space from "../models/space.js";
import Profile from "../models/profile.js";
import { space_notification_queue } from "../utils/schedule_task.js";

class SpaceController {
  static create = async (req, res, next) => {
    const { title, schedule_date, favourite_topics } = req.body;
    console.log(schedule_date);

    try {
      const profile = await Profile.findOne({ user: req.user_id });

      const space = Space.create({
        owner: profile._id,
        title: title,
        description: req.body.description ?? null,
        space_topics: favourite_topics,
        schedule_date: schedule_date,
      });
      return res.status(201).send({
        message: "space created successfully",
        success: true,
      });
    } catch (error) {
      console.log(error);
      res.status(500).send({
        errors: {
          details: ["something went worng"],
        },
        success: false,
      });
    }
  };

  static update = async (req, res) => {
    const { id } = req.params;
    try {
      const space = await Space.findOne({ _id: id });
      console.log(space);

      if (space) {
        const new_space = await space.populate("owner", "user");

        // console.log(new_space);
        if (new_space.owner.user == req.user_id) {
          space.title = req.body.title ?? space.title;
          space.description = req.body.description ?? space.description;
          space.space_topics = req.body.space_topics ?? space.space_topics;
          space.schedule_date = req.body.schedule_date ?? space.schedule_date;

          space.save();

          res.status(200).send({
            message: "space updated successfully",
            success: true,
          });
        } else {
          res.status(403).send({
            errors: {
              details: ["forbidden"],
            },
            success: false,
          });
        }
      } else {
        res.status(404).send({
          errors: {
            details: ["space not found"],
          },
          success: false,
        });
      }
    } catch (error) {
      console.log(error);
      res.status(500).send({
        errors: {
          details: ["something went wrong"],
        },
      });
    }
  };

  static retriveSpace = async (req, res) => {
    const { id } = req.params;
    try {
      const space = await Space.findById(id).populate({
        path: "owner",
        populate: { path: "user", select: "email username" },
      });
      if (space) {
        res.status(200).send({
          data: space,
          message: "space found",
          success: true,
        });
      } else {
        res.status(404).send({
          errors: {
            details: ["space not found"],
          },
          success: false,
        });
      }
    } catch (error) {
      console.log(error);
      res.status(500).send({
        errors: {
          details: ["something went wrong"],
        },
      });
    }
  };

  static getAllSpace = async (req, res) => {
    try {
      // const space = await Space.find({}).populate({
      //   path: "owner",
      //   populate: { path: "user", select: "email username" },
      // });
      const space = await Space.find({}).populate("owner");

      // const new_space = space.populate("owner.user");
      res.status(200).send({
        message: "space fetched successfully",
        data: space,
        success: true,
      });
    } catch (error) {
      console.log(error);
      res.status(500).send({
        errors: {
          details: ["something went wrong"],
        },
      });
    }
  };

  static deleteSpace = async (req, res) => {
    const { id } = req.params;
    try {
      const space = await Space.findOne({ _id: id });
      if (space) {
        const new_space = await space.populate("owner", "user");
        if (new_space.owner.user == req.user_id) {
          // await Space.remove({ _id: id });
          console.log(space);
          console.log(space.job_id);
          const job = await space_notification_queue.getJob(space.job_id);
          console.log(job.id);
          await job.remove();
          await Space.deleteOne({ _id: id });

          res.status(200).send({
            message: "space deleted successfully",
            success: true,
          });
        } else {
          res.status(404).send({
            errors: {
              details: ["space not found"],
            },
            success: false,
          });
        }
      } else {
        res.status(404).send({
          errors: {
            details: ["space not found"],
          },
          success: false,
        });
      }
    } catch (error) {
      console.log(error);
      res.status(500).send({
        errors: {
          details: ["something went wrong"],
        },
      });
    }
  };
}

export default SpaceController;
