import Profile from "../models/profile.js";
import cloudinary from "../config/cloudinary.js";

class ProfileController {
  static update = async (req, res) => {
    console.log("update called");
    const { id } = req.params;
    console.log("id", id);
    try {
      const profile = await Profile.findOne({ _id: id });
      console.log(profile);

      if (profile) {
        console.log(profile);
        if (profile.user == req.user_id) {
          console.log("inside profile", req.body.profile_pic);

          if (req.file) {
            let cloud_res = await cloudinary.v2.uploader.upload(req.file.path, {
              folder: "node",
            });
            req.body.profile_pic = cloud_res.secure_url;
          }

          const update_profile = await profile.updateOne({
            profile_pic: req.body.profile_pic ?? profile.profile_pic,
            favourite_topics:
              req.body.favourite_topics ?? profile.favourite_topics,
            followers: req.body.followers ?? profile.followers,
            following: req.body.following ?? profile.following,
          });

          res.status(200).send({
            message: "profile updated successfully",
            success: true,
            data: profile,
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
          message: "profile not found",
          success: false,
        });
      }
    } catch (error) {
      console.log(error);
      res.status(500).send({
        message: "something went wrong",
        status: false,
      });
    }
  };

  static async getProfileById(req, res) {
    console.log("get user by id called");
    const { id } = req.params;
    try {
      const profile = await Profile.findById(id, { password: 0 });
      if (profile) {
        res.status(200).send({
          message: "profile fetched",
          data: profile,
          success: true,
        });
      } else {
        res.status(404).send({
          errors: {
            details: ["user not found"],
          },
        });
      }
    } catch (error) {
      console.log(error);
      res.status(500).send({
        errors: {
          details: ["something went worng"],
        },
      });
    }
  }

  static async getProfile(req, res) {
    try {
      console.log(req.user_id);
      const profile = await Profile.findOne(
        { user: req.user_id },
        { password: 0 }
      );
      if (profile) {
        res.status(200).send({
          message: "",
          data: profile,
          success: true,
        });
      } else {
        res.status(404).send({
          errors: {
            details: ["user not found"],
          },
        });
      }
    } catch (error) {
      console.log(error);
      res.status(500).send({
        errors: {
          details: ["something went worng"],
        },
      });
    }
  }
}

export default ProfileController;
